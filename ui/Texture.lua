require "luagl"
local class = require "pl.class"

class.Texture()

GLFormat = {
	GL_COLOR_INDEX           =         0x1900,
	GL_STENCIL_INDEX         =         0x1901,
	GL_DEPTH_COMPONENT       =         0x1902,
	GL_RED                   =         0x1903,
	GL_GREEN                 =         0x1904,
	GL_BLUE                  =         0x1905,
	GL_ALPHA                 =         0x1906,
	GL_RGB                   =         0x1907,
	GL_RGBA                  =         0x1908,
	GL_LUMINANCE             =         0x1909,
	GL_LUMINANCE_ALPHA       =         0x190A,
}

function GLFormat.Depth(dtype)
	if	dtype == gl.RGB or
		dtype == gl.BGR_EXT then
		return 3
	elseif dtype == gl.RGBA then
		return 4
	end

	return 1
end

function Texture:_init(...)
	local ids = gl.GenTextures(1)
	self.TextureID = ids[1]

	-- Copy the data to the actual texture object
	gl.PixelStore(gl.UNPACK_ALIGNMENT, 1)

	-- Create Nearest Filtered Texture
	--gl.BindTexture('TEXTURE_2D', self.TextureID)
	--gl.TexParameter('TEXTURE_2D','TEXTURE_MIN_FILTER','NEAREST')
	--gl.TexParameter('TEXTURE_2D','TEXTURE_MAG_FILTER','NEAREST')

	-- Create Linear Filtered Texture
	gl.BindTexture('TEXTURE_2D', self.TextureID)
	gl.TexParameter('TEXTURE_2D','TEXTURE_MIN_FILTER','LINEAR')
	gl.TexParameter('TEXTURE_2D','TEXTURE_MAG_FILTER','LINEAR')

	if arg.n == 1 then
		-- single argument is a pixelarray
		local pixArray = arg[1]
		self.glformat = GLFormat.GL_RGBA
		self.glPixelSize = GLFormat.Depth(self.glformat)
		self.height = #pixArray.pixels
		self.width = #pixArray.pixels[1] / self.glPixelSize

		gl.Enable('TEXTURE_2D')            -- Enable Texture Mapping
		self:MakeCurrent();
		gl.PixelStore(gl.UNPACK_ALIGNMENT, 1)

		--gl.TexImage(0, self.glPixelSize, GLFormat.GL_RGBA, pixArray.pixels)
		gl.TexImage(0, self.glPixelSize, 'RGBA',  pixArray.pixels)

		-- Copy the pixel data into the texture object
		gl.TexSubImage(0, 'RGBA', pixArray.pixels, 0)
		--gl.Finish()
	elseif arg.n == 4 then
		-- Fields
		self.width = arg[1]
		self.height = arg[2]
		self.glformat = arg[3]
		self.glPixelSize = GLFormat.Depth(self.glformat)

		local gldata = arg[4]
		-- Copy the actual data
		-- if it's nil, then only space will be allocated
		gl.TexImage2D(0, self.glPixelSize, self.width, self.height, 0, self.glformat, gl.UNSIGNED_BYTE, gldata);

		-- Flush command cache
		gl.Flush()
	end
end

function Texture.CopyGLData(self, img)
	local gldata, glformat = img:GetOpenGLData()

	-- Enable Texture Mapping
	gl.Enable('TEXTURE_2D')
	self:MakeCurrent();
	gl.PixelStore(gl.UNPACK_ALIGNMENT, 1)
	self.glformat = glformat

	-- Copy the pixel data into the texture object
	--gl.TexImage2D(0, self.glPixelSize, self.width, self.height, 0, self.glformat, gl.UNSIGNED_BYTE, gldata);
--print("Texture.CopyGLData() - ",self.width, self.height, self.glformat, self.glPixelSize)

	gl.TexSubImage2D (0, 0, 0, self.width, self.height, 'RGBA', gl.UNSIGNED_BYTE, gldata)
end

function Texture.MakeCurrent(self)
--print("Texture.MakeCurrent() - ID: ", self.TextureID);
  gl.BindTexture('TEXTURE_2D', self.TextureID)
end


function Texture.CreatePixelArray(self)
	-- get a copy of the texture data into an array
	gl.Enable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )

	self:MakeCurrent()
	gl.PixelStore(gl.PACK_ALIGNMENT, 1)

	-- Get the pixel array
	local pixels1D = gl.GetTexImage('TEXTURE_2D', 0, 'RGBA')

	-- Convert to 2D array, or we can't feed it back to TexSubImage()
	local pixels = create2DPixelArray(self.width, self.height, self.glPixelSize, pixels1D)

	gl.Disable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )

	return pixels
end

function Texture.CopyFromPixelArray(self)
end

function Texture.Render(self, x, y, awidth, aheight)
	x = x or 0
	y = y or 0
	awidth = awidth or self.width
	aheight = aheight or self.height

	gl.PixelStore(gl.UNPACK_ALIGNMENT, 1)

	gl.Enable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )

	self:MakeCurrent()


	gl.Begin('QUADS')
		gl.Normal( 0, 0, 1)                      -- Normal Pointing Towards Viewer

		gl.TexCoord(0, 0)
		gl.Vertex(x, y+aheight,  0)  -- Point 1 (Front)

		gl.TexCoord(1, 0)
		gl.Vertex( x+awidth, y+aheight,  0)  -- Point 2 (Front)

		gl.TexCoord(1, 1)
		gl.Vertex( x+awidth,  y,  0)  -- Point 3 (Front)

		gl.TexCoord(0, 1)
		gl.Vertex(x,  y,  0)  -- Point 4 (Front)
	gl.End()

	-- Disable Texture Mapping
	gl.Disable('TEXTURE_2D')
end

function create2DPixelArray(w, h, depth, pixels1D)
	-- create 2D pixel array
	local pixels2D = {}
	local offset = 1
	for row=1,h do
		local rowarray = {}
		-- A single row
		for col=1, w do
			-- A single pixel
			for comp=1,depth do
				table.insert(rowarray, pixels1D[offset])
				offset = offset + 1
			end
		end
		table.insert(pixels2D, rowarray)
	end

	return pixels2D
end
