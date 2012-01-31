
require("luagl")
require("imlua")
local class = require "pl.class"
require "Actor"

class.PImage(Actor)


function PImage:_init(params)
	params = params or {}

	params.Origin = params.Origin or {0,0}
	params.Extent = params.Extent or {0,0}
	local filename = params.Filename


	if filename then
		local image = im.FileImageLoad(filename) -- directly load the image at index 0. it will open and close the file
		if image == nil then
			print("File: ", filename, "Not Loaded")
			return nil
		end

		self.Image = image;
		params.Extent = {image:Width(), image:Height()}
	else
		--self.Image = im.CreateImage(params.Width, params.Height);
	end


	self:super(params)
end

function PImage:Render(graphPort)
	graphPort:DrawImage(self.Image,
		self.Origin[1], self.Origin[2],
		self.Extent[1], self.Extent[2])
end

--[[

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
--]]

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
print("PImage.lua - TEST")

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
