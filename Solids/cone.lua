-- cone.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
--require ("CADVM")
--require ("trimesh")

-- Create the prototypical cone
local class = require "pl.class"

class.shape_cone()

function shape_cone:_init(o)
	o = o or {}		-- create object if user does not provide one

	self.anglesteps = o.anglesteps
	self.stacksteps = o.stacksteps
	self.baseradius = o.baseradius
	self.topradius = o.topradius
	self.height = o.height

end

-- Returns a point on the surface given the angle and the position along the line
function param_cone(u, lp1, lp2, angle)
	local p = {
		lerp(lp1, lp2, u)[1]*math.cos(angle),
		lerp(lp1, lp2, u)[1]*math.sin(angle),
		lerp(lp1, lp2, u)[2],
		}

	return p
end

function shape_cone.vindex(self, col, row)
	local index = row*(self.anglesteps+1) + col + 1
	return index;
end

function shape_cone.triangle_faces_for_grid(self, width, height)
	local indices = {};
	local lastcol = width
	local lastrow = height

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

function shape_cone.GetMesh(self)
	local lp1 = {self.baseradius,0, 0}
	local lp2 = {self.topradius, 0, self.height}

	local mesh = trimesh({name=self.name})
	local stepangle = 2*math.pi/self.anglesteps;

	for stack = 0, self.stacksteps do
		local v = stack/self.stacksteps
		for astep = 0, self.anglesteps do
			local terp = lerp(lp1, lp2, v)
			local angle = astep * stepangle
			local p = {
				terp[1]*math.cos(angle),
				terp[1]*math.sin(angle),
				lerp(lp1, lp2, v)[3],
			}

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
