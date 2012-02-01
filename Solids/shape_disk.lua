
local class = require "pl.class"

class.shape_disk()
function shape_disk:_init(o)
	o = o or {}		-- create object if user does not provide one

	self.InnerRadius = o.InnerRadius or 0
	self.Radius = o.Radius or 1
	self.Offset = o.Offset or 0
	self.PhiMax = o.PhiMax or 2*math.pi
	self.Resolution = o.Resolution or {36,2}
end

function shape_disk.vindex(self, col, row)
	local index = row*(self.Resolution[1]+1) + col + 1
	return index;
end

function shape_disk.triangle_faces(self)
	local indices = {};

	for row =0, self.Resolution[2]-1 do
		local quadstrip = {};

		for col =0, self.Resolution[1]-1 do
			local tri1 = {self:vindex(col, row), self:vindex(col+1, row), self:vindex(col+1,row+1)}
			local tri2 = {self:vindex(col, row), self:vindex(col+1, row+1), self:vindex(col, row+1)}

			table.insert(indices, tri1)
			table.insert(indices, tri2)
		end
	end

	return indices;
end

function shape_disk.GetVertex(self, u, v)
	local phi = u*self.PhiMax
	local x = ((1-v)*self.InnerRadius + v*self.Radius) * math.cos(phi)
	local y = ((1-v)*self.InnerRadius + v*self.Radius) * math.sin(phi);
	local z = self.Offset

	return {x,y,z}
end

function shape_disk.GetVertices(self)

	local vertices = {}
	local texcoord = {}

	for i = 0,self.Resolution[2] do
		local v = i/self.Resolution[2]
		for j = 0,self.Resolution[1] do
			local u = j/self.Resolution[1]


			local vt = self:GetVertex(u,v);
			local uv = {u,v}
			table.insert(vertices, vt)
			table.insert(texcoord, uv)
		end
	end

	return vertices, uv;
end

function shape_disk.GetMesh(self)
	local mesh = trimesh({name='disk'})

	local verts = self:GetVertices()
	for _,v in ipairs(verts) do
		mesh:addvertex(v)
	end

	-- Now that we have all the vertices
	-- Add all the faces
	local indices = self:triangle_faces(self.anglesteps, self.stacksteps);

	for i,f in ipairs(indices) do
		mesh:addface(f)
	end

	return mesh
end

