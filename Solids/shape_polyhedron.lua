-- shape_polyhedron.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
-- require ("trimesh")
-- vertices
-- faces
--

local class = require "pl.class"

class.shape_polyhedron()

function shape_polyhedron:_init(params)
	params = params or {}

	self.vertices = params.vertices or {}
	self.faces = params.faces or {}
end

function shape_polyhedron.GetMesh(self)
	local mesh = trimesh({name="polyhedron"})

	for i,v in ipairs(self.vertices) do
		mesh:addvertex(v);
	end

	for j,face in ipairs(self.faces) do
		mesh:addface(face)
	end

	return mesh;
end

return shape_polyhedron
