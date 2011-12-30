local class = require "pl.class"

local bit = require "bit"
local band = bit.band
local lshift = bit.lshift
local rshift = bit.rshift


function rgba(c)
	local b = band(c, 0xff)
	c = rshift(c,8)
	local g = band(c, 0xff)
	c = rshift(c,8)
	local r = band(c, 0xff)
	c = rshift(c, 8)
	local a = band(c, 0xff)

	return r,g,b,a
end

function rgbaNormalized(c)
	local r,g,b,a = rgba(c)

	return {r/255, g/255, b/255, a/255}
end



class.Color()

function Color:_init(r,g,b,a)
	self.IntValue = lshift(a, 24) + lshift(r, 16) + lshift(g, 8) + b

	self.R = r
	self.G = g
	self.B = b
	self.A = a
end

function Color:Normalized()
	if self.Norm == nil then
		self.Norm = {
			self.R/255,
			self.G/255,
			self.B/255,
			self.A/255
		}
	end

	return self.Norm;
end

function Color.__tostring(self)
	return '{'..self.R..','..self.G..','..self.B..','..self.A..'}'
end







function blue(c)
	local b = band(c, 0xff)
	return b
end

function green(c)
	local g = band(rshift(c, 8), 0xff)
	return g
end

function red(c)
	local r = band(rshift(c, 16), 0xff)
	return r
end

function alpha(c)
	local a = band(rshift(c, 24), 0xff)
	return a
end

function color(...)
	-- There can be 1, 2, 3, or 4, arguments
--	print("Color.new - ", arg.n)

	local r = 0
	local g = 0
	local b = 0
	local a = 0

--	if Processing.ColorMode == RGB then
	if true then
		if (arg.n == 1) then
			r = arg[1]
			g = arg[1]
			b = arg[1]
			a = 255
		elseif arg.n == 2 then
			r = arg[1]
			g = arg[1]
			b = arg[1]
			a = arg[2]
		elseif arg.n == 3 then
			r = arg[1]
			g = arg[2]
			b = arg[3]
			a = 255
		elseif arg.n == 4 then
			r = arg[1]
			g = arg[2]
			b = arg[3]
			a = arg[4]
		end
	end

	return Color(r,g,b,a)

end

function background(...)
	local acolor = color(unpack(arg))
--print("background: ", acolor[1], acolor[2], acolor[3], acolor[4])
	return Processing.SetBackgroundColor(acolor)
end

function colorMode(amode)
	-- if it's not valid input, just return
	if amode ~= RGB and amode ~= HSB then return end

	return Processing.SetColorMode(amode)
end

function fill(...)
	-- See if we're being passed a 'Color'
	-- type
	if arg.n == 1 and type(arg[1]) == "table" then
		return Processing.SetFillColor(arg[1])
	end

	local acolor = color(unpack(arg))

	return Processing.SetFillColor(acolor)
end

function noFill()
	local acolor = color(0,0,0,0)

	return Processing.SetFillColor(acolor)
end

function noStroke(...)
	local acolor = color(0,0,0,0)

	return Processing.SetStrokeColor(acolor)
end

function stroke(...)
	if arg.n == 1 and type(arg[1]) == "table" then
		-- We already have a color structure
		-- so just set it
		return Processing.SetStrokeColor(arg[1])
	end

	-- Otherwise, construct a new color object
	-- and set it
	local acolor = color(unpack(arg))

	return Processing.SetStrokeColor(acolor)
end

--[[
print("Color.lua - TEST")

local c1 = color(10, 20, 30, 100)

print(red(c1), green(c1), blue(c1), alpha(c1))

--background(102,200,30)
--]]
