local class = require "pl.class"
local bit = require "bit"

local band = bit.band
local lshift = bit.lshift
local rshift = bit.rshift


class.Color()

function Color:_init(r,g,b,a)
	a = a or 255

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


