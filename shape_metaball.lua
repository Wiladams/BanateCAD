-- shape_metaball.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--


--require ("trimesh")
--require ("maths")
require ("openscad_print")

local MIN_THRESHOLD = 0.98;
local MAX_THRESHOLD = 1.02;

-- Another influence function
-- http://www.geisswerks.com/ryan/BLOBS/blobs.html

-- g(r) = 6r^5 - 15r^4 + 10r^3
-- g(r) = r * r * r * (r * (r * 6 - 15) + 10)

-- metaball - x, y, z, radius
function MetaInfluence(pt,ball, scale)
	local val = scale * math.pow( (math.pow((vec3_sub(pt-ball)),2)/(ball[4]*ball[4]))-1,4)

	return val
end

function  MBInfluence(x, y, z, mball)
	local x2 = (x-mball[1])*(x-mball[1]);
	local y2 = (y-mball[2])*(y-mball[2]);
	local z2 = (z-mball[3])*(z-mball[3]);

	return (mball[4] / math.sqrt(x2 + y2 + z2));
end


function SumInfluence(x,y,z, ballList)
	local sum = 0;

	for i,ball in ipairs(ballList) do
		sum = sum + MBInfluence(x,y,z, ball)
	end
	return sum;
end

-- balls
-- radius
-- stacksteps
-- anglesteps
-- name
--
-- Create the prototypical cone
shape_metaball = {}
function shape_metaball:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	o.atcenter = centroid(o.balls)
	return o
end

function shape_metaball.vindex(self, col, row)
	local index = row*(self.anglesteps+1) + col + 1
	return index;
end

function shape_metaball.triangle_faces_for_grid(self)
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


-- Recursively search down the beam
-- until we bump into the surface
function shape_metaball.beamsearch(self, longitude, latitude, high, low)
	-- If the high and low have met, then there's no
	-- intersection with the surface
	if (high - low) < Cepsilon then
		return {0,0,0}
	end

	local midpoint = low + (high-low)/2

	-- start with the midpoint
	local xyz = vec3_add(self.atcenter, sph_to_cart(sph(longitude, latitude, midpoint)))
	local sum = SumInfluence(xyz[1],xyz[2],xyz[3], self.balls);


	if sum > MIN_THRESHOLD and sum < MAX_THRESHOLD then
		return xyz;
	end

	-- Test to see if we're 'outside'
	if sum < MIN_THRESHOLD then
		-- we're outside, so we want to try again with
		-- midpoint and lower
		return self:beamsearch(longitude, latitude, midpoint, low)
	end

	-- If we're 'inside'
	if sum > MAX_THRESHOLD then
		return self:beamsearch(longitude, latitude, high, midpoint)
	end


end

function shape_metaball.param_metaball(self, u, v)
	-- We have the latitude and longitude
	-- We want to descend down the radius until
	-- we intersect the object
	-- Ideally we could just solve for the intersection
	-- perhaps binary search?
	local longitude = u * 2 * math.pi;
	local latitude = math.pi - v * math.pi;

	xyz = self:beamsearch(longitude, latitude, self.radius, 0)
	return xyz;
--[[
	-- Beam Search
	for step = 0, self.beamsteps do
		local probe = self.radius - (step * beamincr)
		local xyz = vec3_add(self.atcenter, sph_to_cart(sph(longitude, latitude, probe)))

		sum = SumInfluence(xyz[1],xyz[2],xyz[3], self.balls);
		if sum > MIN_THRESHOLD and sum < MAX_THRESHOLD then
			return xyz;
		end
	end

	return {0,0,0};
--]]
end

function shape_metaball.GetVertices(self)
	local vertices = {}

	for stack = 0, self.stacksteps do
		local v = stack/self.stacksteps
		for astep = 0, self.anglesteps do
			u = astep/self.anglesteps

			p = self:param_metaball(u, v)
			if p ~= nil then
				table.insert(vertices, p)
			end
		end
	end

	return vertices;
end

function shape_metaball.GetMesh(self)

	local mesh = trimesh:new({name='metaball'})

	local verts = self:GetVertices()
	for i,v in ipairs(verts) do
		mesh:addvertex(v)
	end

	-- Now that we have all the vertices
	-- Add all the faces
	local indices = self:triangle_faces_for_grid(self.anglesteps, self.stacksteps);

	for i,v in ipairs(indices) do
		mesh:addface(v)
	end

	return mesh
end



lshape = shape_metaball:new({
		balls = {{-7, -12, 0, 5}, {8, -12, 0, 5}, {-2, 13, 0, 5}},
		radius = 200,
		stacksteps = 10,
		anglesteps = 10
		});

--mesh = lshape:GetMesh()

--verts = lshape:GetVertices();

--for i,v in ipairs(verts) do
--	vec3_print_tuple(v)
--	translate(v)
--	hexahedron(0.25)
--end
