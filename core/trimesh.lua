--
-- trimesh.lua
--
-- implementation of triangle mesh for BanateCAD
-- Copyright (c) 2011  William Adams
--

trimesh = {
	name='trimesh'
	}

function trimesh:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end


-- Add a vertex to the mesh
function trimesh:addvertex(v)
	if self.vertices == nil then
		self.vertices = {}
	end

	table.insert(self.vertices, v)

	return #self.vertices;
end

function trimesh:addvertices(verts)
	for i,v in ipairs(verts) do
		self:addvertex(v)
	end

	return #self.vertices;
end

-- Add a face to the mesh
function trimesh:addface(face)
	if self.faces == nil then
		self.faces = {}
	end

	local p0 = self.vertices[face[1]];
	local p1 = self.vertices[face[2]];
	local p2 = self.vertices[face[3]];

	local vec1 = vec3_sub(p0, p1);
	local vec2 = vec3_sub(p2, p1);

	local norm = vec3_cross(vec2, vec1);

--print("normal ", normal);

	face.normal = norm;

	-- Add the face to the list of faces
	table.insert(self.faces, face)

	return #self.faces;
end

function trimesh:addedge(v1, v2, f1, f2)
	if self.edges == nil then
		self.edges = {}
	end

	table.insert(self.edges, {v1,v2,f1, f2})

	return #self.edges;
end
