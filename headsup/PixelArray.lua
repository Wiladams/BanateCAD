local class = require "pl.class"

class.PixelArray()

--[[
	Pixel Array is the most basic representation of pixel information.

	Internal storage is normalized values (between 0 and 1)
	Whereas get() and set() utilize values between 0 and 255
--]]

function PixelArray:_init(awidth, aheight, acolor)
	local norm = acolor:Normalized()

	local r = norm[1]
	local g = norm[2]
	local b = norm[3]
	local a = norm[4]

	-- create 2D pixel array
	self.width = awidth;
	self.height = aheight;
	self.pixels = {};

	for row=1,self.height do
		local rowarray = {}
		-- A single row
		for col=1, self.width do
			-- A single pixel
			table.insert(rowarray, r)
			table.insert(rowarray, g)
			table.insert(rowarray, b)
			table.insert(rowarray, a)
		end
		table.insert(self.pixels, rowarray)
	end

	return self
end

function PixelArray.get(self, x, y)
	local row = self.height - y
	local col = 1 + (x*4)

	local r = self.pixels[row][col+0]
	local g = self.pixels[row][col+1]
	local b = self.pixels[row][col+2]
	local a = self.pixels[row][col+3]

	return Color(r*255,g*255,b*255,a*255)
end

function PixelArray.set(self, x, y, acolor)

	local row = self.height - y
	local col = 1 + (x*4)

	local norm = acolor:Normalized()

	self.pixels[row][col+0] = norm[1]	-- red
	self.pixels[row][col+1] = norm[2]	-- green
	self.pixels[row][col+2] = norm[3]	-- blue
	self.pixels[row][col+3] = norm[4]	-- alpha
end

function PixelArray.loadPixels(self)
end

function PixelArray.updatePixels(self)
	self.Texture = Texture(self)
end

function PixelArray.Render(self, x, y, awidth, aheight)
	self.Texture:Render(x, y, awidth, aheight)
end
