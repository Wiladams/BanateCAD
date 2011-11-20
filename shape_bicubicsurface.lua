-- shape_bicubicsurface.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
require ("trimesh")

shape_bicubicsurface = {}

function shape_bicubicsurface:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end

function shape_bicubicsurface.getindex(self, row, column)
	return row*(self.usteps+1) + column + 1
end

function shape_bicubicsurface.getfaces(self, width, height)
	local faces = {};

	for w=0, self.wsteps-1 do
		for u=0, self.usteps-1 do
			local v1 = self:getindex(w, u)
			local v2 = self:getindex(w, u+1)
			local v3 = self:getindex(w+1, u+1)
			local v4 = self:getindex(w+1, u)

			local tri1 = {v1, v2, v3}
			local tri2 = {v1, v3, v4}

			table.insert(faces, tri1)
			table.insert(faces, tri2)
		end
	end

	return faces;
end

function shape_bicubicsurface.GetMesh(self)
--(M, umult, mesh, usteps, wsteps)

	local mesh = trimesh:new();

	local vertices = {};
	--local innerverts = {};
	--local normals = {};

	for w=0, self.wsteps do
		for u=0, self.usteps do
			local svert, normal = bicerp(u/self.usteps, w/self.wsteps, self.mesh, self.M, self.umult);
			svert.normal = normal

			mesh:addvertex(svert)
		end
	end

	local faces = self:getfaces()
	for _,f in ipairs(faces) do
		mesh:addface(f)
	end

	return mesh
end



