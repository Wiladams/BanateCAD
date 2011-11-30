-- shape_polyhedron.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
require ("CADVM")
--require ("trimesh")

-- Create the prototypical cone
--
-- vertices
-- faces
--
shape_polyhedron = {}

function shape_polyhedron:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end

function shape_polyhedron.GetMesh(self)
	local mesh = trimesh:new({name="polyhedron"})

	for i,v in ipairs(self.vertices) do
		mesh:addvertex(v);
	end

	for j,face in ipairs(self.faces) do
		mesh:addface(face)
	end

	return mesh;
end
