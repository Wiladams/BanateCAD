-- checkerboard.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
-- A procedural texture for a checkerboard pattern
--

local class = require "pl.class"

function isodd(x)
	return math.mod(x,2) == 1;
end

function iseven(x)
	return not isodd(x);
end

function map_array(range, u)
	if (u*range) >= range then
		return  range-1
	end

	return math.floor(u*range);
end

class.checkerboard()

function checkerboard:_init(o)
	o = o or {}		-- create object if user does not provide one

	self.Columns = o.Columns or 8
	self.Rows = o.Rows or 8
	self.LowColor = o.LowColor or {0,0,0,1}
	self.HighColor = o.HighColor or {1,1,1,1}

	return self
end

-- Fixed grid checkerboard
function checkerboard.GetColor(self, u,v)
	local colrow = map_array(self.Columns,u) + map_array(self.Rows,v)

	if iseven(colrow) then
		return self.LowColor
	end

	return self.HighColor
end

function checkerboard.GetHeight(self, u,v)
	local colrow = map_array(self.Columns,u) + map_array(self.Rows,v)

	if iseven(colrow) then
		return 0
	end

	return 1
end

function checkerboard.__tostring(self)
	return '{'.."Columns = "..self.Columns..", Rows = "..self.Rows..'}'
end

--[[
local cb = checkerboard()
print(cb)
--]]
