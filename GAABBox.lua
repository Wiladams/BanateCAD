--
-- GAABBox.lua
--
-- Graphic Axis Aligned Bounding Box
-- Copyright (c) 2011  William Adams
--

require ("Class")
require ("Shape")
require ("openscad_print")


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

GAABBox = inheritsFrom(Shape)



-- Now we construct our own 'new' function so that we can
-- do whatever special setup we want to do on our own.
-- If we're setting any instance variables, we use 'self.'
-- At the end we return 'self' to retain the metatable
-- That was set when we subclassed Shape.
---[[
function GAABBox.new(o)
	o = o or {}		-- create object if user does not provide one
	o[1] = o[1] or {0,0,0}
	o[2] = o[2] or {0,0,0}

	local new_inst = GAABBox.create()
	new_inst:Init(o[1], o[2])

	return new_inst
end
--]]

function GAABBox.Init(self, v1,v2)
	v1 = v1 or {0,0,0}
	v2 = v2 or {0,0,0}
	v1, v2 = sortvertices(v1, v2)
	self.LowerVertex = v1
	self.HigherVertex = v2
	self.Dimensions = {v2[1]-v1[1], v2[2]-v1[2], v2[3]-v1[3]}

	self.Vertices = {
		{v1[1],v1[2],v1[3]},
		{v2[1],v1[2],v1[3]},
		{v2[1],v1[2],v2[3]},
		{v1[1],v1[2],v2[3]},

		{v1[1],v2[2],v1[3]},
		{v2[1],v2[2],v1[3]},
		{v2[1],v2[2],v2[3]},
		{v1[1],v2[2],v2[3]},
	}

	self.Edges = {
		{1,2},
		{2,3},
		{3,4},
		{4,1},

		{5,6},
		{6,7},
		{7,8},
		{8,5},

		{1,5},
		{2,6},
		{3,7},
		{4,8},
	}

	return self
end

function GAABBox.RenderSelf(self, renderer)
print("GAABBox.RenderSelf: ", self:ToString())

	for _,e in ipairs(self.Edges) do
		renderer:DrawLine({self.Vertices[e[1]], self.Vertices[e[2]], 1})
	end
end

function GAABBox.ToString(self)
	return "<Dimensions>"..self.Dimensions[1]..','..self.Dimensions[2]..','..self.Dimensions[3]
end

--[[	Testing
local bbox = GAABBox.new({{3,2,-3},{10,10,10}})
print(bbox:ToString())
--]]
