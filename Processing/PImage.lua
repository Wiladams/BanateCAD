require("imlua")
--require "color"

PImage={}
PImage_mt = {}
PImage_mt.__index = PImage;

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

function PImage.new(filename)
	new_inst = {}

	-- load the bitmap
	local bm = im.FileImageLoadBitmap(filename)

	if bm == nil then return nil end


	local gldata, glformat = bm:GetOpenGLData()

	-- Fields
	new_inst.Bitmap = bm
	new_inst.width = bm:Width()
	new_inst.height = bm:Height()
	new_inst.pixels = gldata

	new_inst.PixelSize = GLFormat.PixelSize(glformat)
	new_inst.LineSize = new_inst.PixelSize * new_inst.width
	new_inst.Size = new_inst.LineSize*new_inst.height

	new_inst.GLFormat = glformat

	setmetatable(new_inst, PImage_mt)

	return new_inst
end

function PImage.get(self, x, y)
	local offset = y*self.LineSize + x*self.PixelSize

	local r = self.Bitmap[0][self.height-1-y][x]
	local g = self.Bitmap[1][self.height-1-y][x]
	local b = self.Bitmap[2][self.height-1-y][x]
	local a = self.Bitmap[3][self.height-1-y][x]

	return r,g,b,a
end

function PImage.set(self, x, y, acolor)
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
  iup.GLMakeCurrent(self)
  gl.PixelStore(gl.UNPACK_ALIGNMENT, 1)
  --gl.Clear('COLOR_BUFFER_BIT,DEPTH_BUFFER_BIT') -- Clear Screen And Depth Buffer

  gl.DrawPixelsRaw (self.Width, self.Height, self.Format, gl.UNSIGNED_BYTE, self.Pixels)

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

---[[
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
