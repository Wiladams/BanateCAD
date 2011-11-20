-- checkerboard.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
-- A procedural texture for a checkerboard pattern
--
function mod(x,y)
	return x-(y*math.floor(x/y));
end

function isodd(x)
	return mod(x,2) == 1;
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

	return o
end

-- Fixed grid checkerboard
function checkerboard.getcolor(self, u,v)
local colrow = map_array(self.columns,u) + map_array(self.rows,v)

	if iseven(colrow) then
		return {0,0,0}
	end

	return {1,1,1}
end

