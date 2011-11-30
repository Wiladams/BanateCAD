-- shape_hyperboloid.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
--require ("trimesh")
require ("Shape")
require ("BiParametric")


-- USteps
-- WSteps
-- ZMin
-- ZMax
-- RadiusMax
--
shape_hyperboloid = inheritsFrom(BiParametric)
function shape_hyperboloid.new(params)
	local new_inst = shape_hyperboloid.create()
	new_inst:Init(params)

	return new_inst
end


function shape_hyperboloid.Init(self, params)
	params = params or {}

	-- Allow the base class to pull out what it wants
	--self:superClass():Init(params)
	self.USteps = params.USteps or 10
	self.WSteps = params.WSteps or 10
	self.ColorSampler = params.ColorSampler or nil

	-- Get our specifics out of the parameters
	params.PhiMax = params.PhiMax or 360
	self.PhiMax = math.rad(params.PhiMax)

	self.StartPoint = params.StartPoint or {1,0,0}
	self.EndPoint = params.EndPoint or {1,1,1}

	return self
end


-- Given parametric u, and v, return coordinates
-- on the surface of the ellipsoid
function shape_hyperboloid.GetVertex(self, u, w)
	local phi = u * self.PhiMax

	local xr = (1-w)*self.StartPoint[1] + w*self.EndPoint[1]
	local yr = (1-w)*self.StartPoint[2] + w*self.EndPoint[2]
	local x = xr * math.cos(phi) - yr*math.sin(phi)
	local y = xr*math.sin(phi) + yr*math.cos(phi)
	local z = (1-w)*self.StartPoint[3] + w * self.EndPoint[3]

	return {x,y,z}
end
