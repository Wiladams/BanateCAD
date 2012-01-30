--
-- BoundingBox.lua
--
-- Graphic Axis Aligned Bounding Box
-- Copyright (c) 2011  William Adams
--

local class = require "pl.class"

--require ("Shape")


-- An Axis Aligned Bounding Box is a simple construction
-- It requires only two vertices in space to define it.
-- It does not matter what order the vertices are given,
-- The coordinates will be sorted, to form a box that is
-- aligned with the x,y,and z axes
--



-- This is how we do simple single inheritance
-- Our 'class' GAABBox, will inherit from the base class
-- 'Shape'.  So, we call the 'new()' method on the base
-- class.  At that point we have an empty subclass, that
-- inherits all the methods of the base class.

class.BoundingBox()

-- Now we construct our own 'new' function so that we can
-- do whatever special setup we want to do on our own.
-- If we're setting any instance variables, we use 'self.'
-- At the end we return 'self' to retain the metatable
-- That was set when we subclassed Shape.

function BoundingBox:_init(params)
	self:SetBounds(vec3(0,0,0), vec3(0,0,0))
end

function BoundingBox.SetBounds(self, v1, v2)
	self.LowerVertex = v1
	self.HigherVertex = v2
	self.Dimensions = vec.new(v2)-vec.new(v1)
end



-- Expand our borders by union with
-- a new point
function BoundingBox.Union(self, pt)
--	local apt = vec.new(pt)
	local newlow = min(self.LowerVertex, pt)
	local newhigh = max(self.HigherVertex, pt)

	self:SetBounds(newlow, newhigh)
end

--[[
print("BoundingBox.lua - TEST");
local bbox1 = BoundingBox.new()
--]]
