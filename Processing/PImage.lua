
require("luagl")
require("imlua")
local class = require "pl.class"


local GLFormat = {
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


class.PImage()


function PImage:_init(filename)
	-- load the bitmap
	local bm = im.FileImageLoadBitmap(filename)

	if bm == nil then
		print("File: ", filename, "Not Loaded")
		return nil
	end

	self.Bitmap = bm
	self.width = bm:Width()
	self.height = bm:Height()
	self.depth = bm:Depth()


	-- Fields
	local ids = gl.GenTextures(1)
	self.TextureID = ids[1]

	-- Create Nearest Filtered Texture
	--gl.BindTexture('TEXTURE_2D', self.TextureID)
	--gl.TexParameter('TEXTURE_2D','TEXTURE_MIN_FILTER','NEAREST')
	--gl.TexParameter('TEXTURE_2D','TEXTURE_MAG_FILTER','NEAREST')

	-- Create Linear Filtered Texture
	gl.BindTexture('TEXTURE_2D', self.TextureID)
	gl.TexParameter('TEXTURE_2D','TEXTURE_MIN_FILTER','LINEAR')
	gl.TexParameter('TEXTURE_2D','TEXTURE_MAG_FILTER','LINEAR')

	-- Copy the data to the actual texture object
	gl.PixelStore(gl.UNPACK_ALIGNMENT, 1)
	local gldata, glformat = bm:GetOpenGLData()

	self.glformat = glformat;
	self.GLPixelSize = GLFormat.Depth(glformat)
	self.GLLineSize = self.GLPixelSize * self.width
	self.GLSize = self.GLLineSize*self.height

--print("Texture._init - ", self.width, self.height, self.GLPixelSize, self.width*self.height*self.GLPixelSize);

	-- Initial copy to texture using the userdata
	gl.TexImage2D(0, self.GLPixelSize, self.width, self.height, 0, self.glformat, gl.UNSIGNED_BYTE, gldata)
	gl.Flush()

	bm:Destroy()

	return self
end



function PImage.Render(self, x, y, awidth, aheight)

  gl.PixelStore(gl.UNPACK_ALIGNMENT, 1)

  gl.Enable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )
  gl.BindTexture('TEXTURE_2D', self.TextureID)


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

function create2DPixelArray(width, height, depth, pixels1D)
	-- create 2D pixel array
	local pixels2D = {}
	local offset = 1
	for row=1,height do
		local rowarray = {}
		-- A single row
		for col=1, width do
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

function PImage.loadPixels(self)
	-- get a copy of the texture data into an array
	gl.Enable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )
	gl.BindTexture('TEXTURE_2D', self.TextureID)
	gl.PixelStore(gl.PACK_ALIGNMENT, 1)

	-- Get the pixel array
	local pixels1D = gl.GetTexImage('TEXTURE_2D', 0, 'RGBA')
	-- Convert to 2D array, or we can't feed it back to TexSubImage()
	self.pixels = create2DPixelArray(self.width, self.height, self.GLPixelSize, pixels1D)

--print("Texture.loadPixels - self.pixels type: ", type(self.pixels), type(self.pixels[1]))
--print("Texture.loadPixels - self.pixels size: ", #self.pixels)

	gl.Disable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )
end

function PImage.updatePixels(self)
	-- If we don't have any pixels (loadPixels not called)
	-- then we have nothing to copy, so return
	if self.pixels == nil then return end


--print("Texture.updatePixels - Depth: ", self.GLPixelSize)
	-- Copy the pixel data into the texture object
	gl.Enable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )
	gl.BindTexture('TEXTURE_2D', self.TextureID)
	gl.PixelStore(gl.UNPACK_ALIGNMENT, 1)

	--local awidth = gl.GetTexLevelParameter(gl.TEXTURE_2D, 0, gl.TEXTURE_WIDTH)
	--local aheight = gl.GetTexLevelParameter(gl.TEXTURE_2D, 0, gl.TEXTURE_HEIGHT)
	--local adepth = gl.GetTexLevelParameter(gl.TEXTURE_2D, 0, gl.TEXTURE_COMPONENTS)
--print("AWidth: ", awidth," AHeight: ", aheight, " Depth: ", adepth);

	gl.TexSubImage(0, 'RGBA', self.pixels, 0)
	gl.Finish()
--print("Texture.updatePixels - Err: ", gl.GetError())
	--gl.Disable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )

end

function PImage.get(self, x, y)
	if self.pixels == nil then
		return color(0,0,0)
	end

	--local offset = ((self.height-1 - y)*self.GLLineSize + x*self.GLPixelSize) + 1
	local row = self.height - y
	--local row = 1 + y
	local col = 1 + (x*4)


	local r = self.pixels[row][col+0]
	local g = self.pixels[row][col+1]
	local b = self.pixels[row][col+2]
	local a = self.pixels[row][col+3]

--print(y, x, r,g,b,a)
	return Color(r*255,g*255,b*255,a*255)
end

function PImage.set(self, x, y, acolor)
	if self.pixels == nil then
		return
	end

	--local offset = ((self.height-1 - y)*self.GLLineSize + x*self.GLPixelSize) + 1
	local row = self.height - y
	local xoffset = (x*4)+1

	local norm = acolor:Normalized()

	self.pixels[row][xoffset+0] = norm[1]	-- red
	self.pixels[row][xoffset+1] = norm[2]	-- green
	self.pixels[row][xoffset+2] = norm[3]	-- blue
	self.pixels[row][xoffset+3] = norm[4]	-- alpha

end

--[[
print("Texture.lua - TEST")

function print_texture(tex)
	print("Dimension: ", tex.width, tex.height);
	print("Pixel Size: ", tex.GLPixelSize);
	print("Line Size: ", tex.GLLineSize)
	print("Size: ", tex.GLSize)

	print("GLFormat: ", tex.glformat)
	print("Pixels: ", tex.pixels)
end

function print_data_type(dtype)
	print("Data Type: ", dtype)
	print("Data Type Name: ", im.DataTypeName(dtype));
	print("Data Type Size: ", im.DataTypeSize(dtype));

end

function print_color_mode(amode, dtype)
	print("Color Mode: ", amode)
	print("Color Mode Depth: ", im.ColorModeDepth(amode))
	print("Color Mode Name: ", im.ColorModeSpaceName(amode))
	print("Color Mode Packed: ", im.ColorModeIsPacked(amode))
	print("Color Mode Is Top Down: ", im.ColorModeIsTopDown(amode))
	print("Color Mode Is Bitmap: ", im.ColorModeIsBitmap(amode, dtype))
end

local tx = Texture("csg1.png")
tx:loadPixels()

if tx ~= nil then
	print_texture(tx)
end


--local r,g,b,a = tx:get(1,1)

--print(r,g,b,a)

--]]
