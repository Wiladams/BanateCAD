local class = require "pl.class"
local bit = require "bit"

local band = bit.band
local lshift = bit.lshift
local rshift = bit.rshift


class.Color()

function Color:_init(...)
	-- There can be 1, 2, 3, or 4, arguments
--	print("Color.new - ", arg.n)

	local r = 0
	local g = 0
	local b = 0
	local a = 0

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
	local str = string.format("{%u,%u, %u, %u}", self.R, self.G, self.B, self.A)
--	return '{'..self.R..','..self.G..','..self.B..','..self.A..'}'
	return str
end


--[[
print("Color.lua - TEST")
local c1 = Color(0,0,0)
local c2 = Color(127, 127, 127, 127)
local c3 = Color(255, 255, 255)

print(c1)
print(c2)
print(c3)
--]]

return Color
