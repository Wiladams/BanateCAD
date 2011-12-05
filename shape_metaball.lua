-- shape_metaball.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--


--require ("trimesh")
--require ("maths")
require ("openscad_print")

--local MIN_THRESHOLD = 0.999;
--local MAX_THRESHOLD = 1.001;

-- Another influence function
-- http://www.geisswerks.com/ryan/BLOBS/blobs.html

-- g(r) = 6r^5 - 15r^4 + 10r^3
-- g(r) = r * r * r * (r * (r * 6 - 15) + 10)

-- metaball - x, y, z, radius
--[[
function MetaInfluence(pt,ball, scale)
	local val = scale * math.pow( (math.pow((vec3_sub(pt,ball)),2)/(ball[4]*ball[4]))-1,4)

	return val
end
--]]

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

function DiffInfluence(x,y,z, ballList)
	local sum = 0;

	sum = MBInfluence(x,y,z, ballList[1]) - MBInfluence(x,y,z, ballList[2])

	return sum;
end


-- balls
-- radius
--

shape_metaball = inheritsFrom(BiParametric)
function shape_metaball.new(params)
	local new_inst = shape_metaball.create()

	new_inst.balls = params.balls
	new_inst.atcenter = centroid(params.balls)
	new_inst.radius = params.radius or 100
	new_inst.Threshold = params.Threshold or 0.001

	new_inst.Bounds = GAABBox.new()

	new_inst.USteps = params.USteps or 10
	new_inst.WSteps = params.WSteps or 10
	new_inst.ColorSampler = params.ColorSampler or nil
	new_inst.VertexFunction = params.VertexFunction or nil
	new_inst.Thickness = params.Thickness or nil

	new_inst.MaxThreshold = new_inst.Threshold + 1
	new_inst.MinThreshold = 1 - new_inst.Threshold

	return new_inst
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
	--local sum = DiffInfluence(xyz[1],xyz[2],xyz[3], self.balls);

	-- We're right within the threshold, so return the point
	if sum > self.MinThreshold and sum < self.MaxThreshold then
		return xyz;
	end

	-- Test to see if we're 'outside'
	if sum < self.MinThreshold then
		-- we're outside, so we want to try again with
		-- midpoint and lower
		return self:beamsearch(longitude, latitude, midpoint, low)
	end

	-- If we're 'inside'
	-- Try again with midpoint and higher
	if sum > self.MaxThreshold then
		return self:beamsearch(longitude, latitude, high, midpoint)
	end
end

function shape_metaball.GetVertex(self, u, v)
	-- We have the latitude and longitude
	-- We want to descend down the radius until
	-- we intersect the object
	-- Ideally we could just solve for the intersection
	-- perhaps binary search?
	local longitude = u * 2 * math.pi;
	local latitude = math.pi - v * math.pi;

	local xyz = self:beamsearch(longitude, latitude, self.radius, 0)
	local norm = vec3_norm(xyz)

	return xyz, norm;
end

