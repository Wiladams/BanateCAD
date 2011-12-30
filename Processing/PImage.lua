require("imlua")
local class = require "pl.class"

class.PImage()


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
	GL_LUMINANCE_ALPHA       =         0x190A;
}

function GLFormat.PixelSize(dtype)
	if dtype == GLFormat.GL_RGB then
		return 3
	elseif dtype == GLFormat.RGBA then
		return 4
	end

	return 1
end

function PImage:LoadImage(filename)
	-- load the bitmap
	local bm = im.FileImageLoadBitmap(filename)

	if bm == nil then return nil end

	local gldata, glformat = bm:GetOpenGLData()

	-- Fields
	self.Bitmap = bm
	self.width = bm:Width()
	self.height = bm:Height()
	self.pixels = gldata

	self.GLFormat = glformat
	self.GLData = gldata
	self.GLPixelSize = GLFormat.PixelSize(glformat)
	self.GLLineSize = self.GLPixelSize * self.width
	self.GLSize = self.GLLineSize*self.height

	return bm
end

function PImage:CreateImage(awidth, aheight, aformat)
	local img = im.ImageCreate(500, 500, im.RGB, im.BYTE)
	img:AddAlpha()

	self.Bitmap = img
	self.width = img:Width()
	self.height = img:Height()
end

function PImage:_init(...)
	if arg.n == 1 and type(arg[1]) == "string" then
		local filename = arg[1]
		self:LoadImage(filename)
	elseif arg.n == 3 then
		self:CreateImage(unpack(arg))
	end
end


function PImage.get(self, x, y)
	local r = self.Bitmap[0][self.height-1-y][x]
	local g = self.Bitmap[1][self.height-1-y][x]
	local b = self.Bitmap[2][self.height-1-y][x]
	local a = self.Bitmap[3][self.height-1-y][x]

	return r,g,b,a
end

function PImage.set(self, x, y, acolor)
	local offset = y*self.GLLineSize + x*self.GLPixelSize

	self.Bitmap[0][self.height-1-y][x] = acolor.red

end

function PImage.copy(self)
end

function PImage.mask(self)
end

function PImage.blend(self)
end

function PImage.filter(self)
end

function PImage.save(self)
end

function PImage.resize(self)
end

function PImage.loadPixels(self)
	-- do nothing
end

function PImage.updatePixels(self)
	-- do nothing
end


function PImage.Render(self, canvas)
  iup.GLMakeCurrent(canvas)
  gl.PixelStore(gl.UNPACK_ALIGNMENT, 1)
  --gl.Clear('COLOR_BUFFER_BIT,DEPTH_BUFFER_BIT') -- Clear Screen And Depth Buffer

  gl.DrawPixelsRaw (self.width, self.height, self.GLFormat, gl.UNSIGNED_BYTE, self.GLData)

--  iup.GLSwapBuffers(self)
end

function PImage.print(self)
	print("Dimension: ", self.width, self.height);
	print("Line Size: ", self.LineSize)
	print("Size: ", self.Size)
	print("Bitmap: ", self.Bitmap)
	--print("Bitmap metatable: ", getmetatable(self.Bitmap))
	--for k,v in pairs(getmetatable(self.Bitmap)) do
	--	print (k,v)
	--end

	print("GLFormat: ", self.GLFormat)
	print("Pixels: ", self.pixels)
	local c = self:get(1,1)

	local mt = getmetatable(self.pixels)
	print("Pixel Metatable: ", mt)
end

--[[
print("PImage.lua - TEST")

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

local pm = PImage.new("csg1.png")
if pm ~= nil then
	pm:print()
end

--]]
