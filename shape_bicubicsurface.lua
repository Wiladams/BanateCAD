-- shape_bicubicsurface.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
require ("trimesh")
require ("BiParametric")
require ("maths")

-- Create a subclass of BiParametric
shape_bicubicsurface = inheritsFrom(BiParametric)


function shape_bicubicsurface.new(params)
	local new_inst = shape_bicubicsurface.create()
	new_inst:Init(params)

	return new_inst
end

-- USteps
-- WSteps
-- Mesh
-- M
-- UMult
function shape_bicubicsurface.Init(self, params)
	params = params or {}

	self.Thickness = params.Thickness or 1
	self.USteps = params.USteps or 10
	self.WSteps = params.WSteps or 10
	self.M = params.M or cubic_bezier_M()
	self.UMult = params.UMult or 1
	self.Mesh = params.Mesh or {
		{{0,0,0,1},{0.33, 0,0},{0.66,0,0,1},{1,1,0,1}},
		{{0,0.33,0,1},{0.33, 0.33,0,1},{0.66,0.33,0,1},{1,0.33,0,1}},
		{{0,0.66,0,1},{0.33, 0.66,0,1},{0.66,0.66,0,1},{1,0.66,0,1}},
		{{0,1,0,1},{0.33, 1,0,1},{0.66,0,0,1},{1,1,0,1}},
		}
	self.ParamFunction = self

	return self
end

function shape_bicubicsurface.GetValue(self, u,w)
	local svert, normal = bicerp(u, w, self.Mesh, self.M, self.UMult);
	return svert, normal;
end


--[[
function shape_bicubicsurface.GetMesh(self)
	local mesh = trimesh:new();

	local vertices, normals = self:GetVertices()

	for _,vert in ipairs(vertices) do
		mesh:addvertex(vert)
	end

	local faces = self:GetFaces()
	for _,f in ipairs(faces) do
		mesh:addface(f)
	end

	return mesh
end
--]]


