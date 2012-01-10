
require("luagl")
require("imlua")
local class = require "pl.class"

class.PImage()

function PImage.loadBitmapFile(self, filename)
	-- load the bitmap
	bm = im.FileImageLoadBitmap(filename)

	if bm == nil then
		print("File: ", filename, "Not Loaded")
		return nil
	end

	--self.Bitmap = bm
	self.width = bm:Width()
	self.height = bm:Height()
	--self.depth = bm:Depth()

	-- Copy the data to the actual texture object
	local gldata, glformat = bm:GetOpenGLData()

	self.glformat = glformat;

	-- Initial copy to texture using the userdata
	self.Texture = Texture(self.width, self.height, glformat, gldata)

	bm:Destroy()
end

-- Either
-- PImage(filename)
-- PImage(width, height, dtype)
--
function PImage:_init(...)
	self.width = 0;
	self.height = 0;
	--self.depth = 0;

	local bm = nil;

	if arg.n == 1 and type(arg[1]) == 'string' then
		local filename = arg[1]

		self:loadBitmapFile(filename);
	elseif arg.n >= 2 then
		self.width = arg[1]
		self.height = arg[2]

		parray = PixelArray(self.width, self.height, color(0,255))
		self.Texture = Texture(parray)
	end

	return self
end

function PImage.Render(self, x, y, awidth, aheight)

  gl.PixelStore(gl.UNPACK_ALIGNMENT, 1)

  gl.Enable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )

	self.Texture:MakeCurrent()


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
	self.pixels = self.Texture:CreatePixelArray()

--[[
	-- get a copy of the texture data into an array
	gl.Enable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )

	self.Texture:MakeCurrent()
	gl.PixelStore(gl.PACK_ALIGNMENT, 1)

	-- Get the pixel array
	local pixels1D = gl.GetTexImage('TEXTURE_2D', 0, 'RGBA')
	-- Convert to 2D array, or we can't feed it back to TexSubImage()
	self.pixels = create2DPixelArray(self.width, self.height, self.GLPixelSize, pixels1D)

	gl.Disable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )
--]]
end

function PImage.updatePixels(self)
	-- If we don't have any pixels (loadPixels not called)
	-- then we have nothing to copy, so return
	if self.pixels == nil then return end


	gl.Enable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )
	self.Texture:MakeCurrent()

	gl.PixelStore(gl.UNPACK_ALIGNMENT, 1)

	-- Copy the pixel data into the texture object
	gl.TexSubImage(0, 'RGBA', self.pixels, 0)
	gl.Finish()
	--gl.Disable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )
end

function PImage.get(self, x, y)
	if self.pixels == nil then
		return color(0,0,0)
	end

	local row = self.height - y
	local col = 1 + (x*4)

	local r = self.pixels[row][col+0]
	local g = self.pixels[row][col+1]
	local b = self.pixels[row][col+2]
	local a = self.pixels[row][col+3]

	return Color(r*255,g*255,b*255,a*255)
end

function PImage.set(self, x, y, acolor)
	if self.pixels == nil then
		return
	end

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
