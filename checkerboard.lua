-- checkerboard.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
-- A procedural texture for a checkerboard pattern
--


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

checkerboard = {}
function checkerboard:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	o.Columns = o.Columns or 8
	o.Rows = o.Rows or 8
	o.LowColor = o.LowColor or {0,0,0,1}
	o.HighColor = o.HighColor or {1,1,1,1}

	return o
end

-- Fixed grid checkerboard
function checkerboard.GetColor(self, u,v)
local colrow = map_array(self.Columns,u) + map_array(self.Rows,v)

	if iseven(colrow) then
		return self.LowColor
	end

	return self.HighColor
end

