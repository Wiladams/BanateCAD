-- shape_ellipsoid.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
require ("trimesh")

-- xradius
-- yradius
-- stacksteps
-- anglesteps
-- name
--
-- Create the prototypical cone
shape_ellipsoid = {}
function shape_ellipsoid:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end

function shape_ellipsoid.vindex(self, col, row)
	local index = row*(self.anglesteps+1) + col + 1
	return index;
end

function shape_ellipsoid.triangle_faces_for_grid(self)
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

-- Given parametric u, and v, return coordinates
-- on the surface of the ellipsoid
function shape_ellipsoid.param_ellipse(self, u, v)
	theta = u * 2*math.pi
	phi = v * math.pi

	return {
		self.xradius*math.cos(theta),
		self.yradius*math.sin(theta)*math.cos(phi),
		self.yradius*math.sin(theta)*math.sin(phi)};
end

--[[
	xradius = 1,
	yradius = 1,
	anglesteps = 6,
	sweepsteps = 6
--]]
function shape_ellipsoid.GetMesh(self)


	local mesh = trimesh:new({name='ellipsoid'})

	local stackangle = math.pi / self.stacksteps;
	local stepangle = 2*math.pi/self.anglesteps;

	for stack = 0, self.stacksteps do
		local v = stack/self.stacksteps
		for astep = 0, self.anglesteps do
			u = astep/self.anglesteps
			local angle = astep * stepangle

			p = self:param_ellipse(u, v)

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
