-- shape_torus.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--

require ("trimesh")

--[[
{
offset={0,1},
size={0.5,0.5},
--]]

-- Point on the surface of a torus
torus_param = {}
function torus_param:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end

function torus_param.GetPoint(self, u, v)
	local theta = u * 2*math.pi;
	local phi = v * 2*math.pi;

	local pt = {
		(self.offset[2]+self.size[2]*math.sin(theta))*math.sin(phi),
		(self.offset[2]+self.size[2]*math.sin(theta))*math.cos(phi),
		self.offset[1]+self.size[1]*math.cos(theta),
		};
--[[
	local pt = {
		self.offset[1]+self.size[1]*math.cos(theta),
		(self.offset[2]+self.size[2]*math.sin(theta))*math.cos(phi),
		(self.offset[2]+self.size[2]*math.sin(theta))*math.sin(phi)
		};
--]]
	return pt;
end

shape_torus={}
function shape_torus:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end


function shape_torus.vindex(self, col, row)
	local index = row*(self.anglesteps+1) + col + 1
	return index;
end

function shape_torus.triangle_faces_for_grid(self)
	local indices = {};

	for row =0, self.stacksteps-1 do
		local quadstrip = {};

		for col =0, self.anglesteps-1 do
			local tri1 = {self:vindex(col, row), self:vindex(col+1, row), self:vindex(col+1,row+1)}
			local tri2 = {self:vindex(col, row), self:vindex(col+1, row+1), self:vindex(col, row+1)}

			table.insert(indices, tri1)
			table.insert(indices, tri2)
		end
	end

	return indices;
end

--[[
{offset={0,1},
	size={0.5,0.5},
	anglesteps = 12,
	stacksteps = 12}
--]]

function shape_torus.GetMesh(self)

	local mesh = trimesh:new({name='torus'})

	local param_func = torus_param:new({offset = self.offset, size = self.size});
	local stackangle = 2*math.pi / self.stacksteps;
	local stepangle  = 2*math.pi / self.anglesteps;


	for stack = 0, self.stacksteps do
		local v = stack/self.stacksteps
		for astep = 0, self.anglesteps do
			u = astep/self.anglesteps
			local angle = astep * stepangle

			p = param_func:GetPoint(u, v)

			mesh:addvertex(p)
		end
	end

	-- Now that we have all the vertices
	-- Add all the faces
	local indices = self:triangle_faces_for_grid(self.anglesteps, self.stacksteps);

	for i,v in ipairs(indices) do
		mesh:addface(v)
	end

	return mesh
end
