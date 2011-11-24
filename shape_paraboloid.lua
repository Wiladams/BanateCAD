-- shape_paraboloid.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
require ("trimesh")
require ("Shape")
require ("BiParametric")


-- USteps
-- WSteps
-- ZMin
-- ZMax
-- RadiusMax
--
shape_paraboloid = inheritsFrom(BiParametric)
function shape_paraboloid.new(params)
	local new_inst = shape_paraboloid.create()
	new_inst:Init(params)

	return new_inst
end


function shape_paraboloid.Init(self, params)
	params = params or {}

	-- Allow the base class to pull out what it wants
	--self:superClass():Init(params)
	self.USteps = params.USteps or 10
	self.WSteps = params.WSteps or 10
	self.ColorSampler = params.ColorSampler or nil

	-- Get our specifics out of the parameters
	params.PhiMax = params.PhiMax or 360

	self.ZMin = params.ZMin or 0
	self.ZMax = params.ZMax or 1
	self.RadiusMax = params.RadiusMax or 1
	self.PhiMax = math.rad(params.PhiMax)

	return self
end


-- Given parametric u, and v, return coordinates
-- on the surface of the ellipsoid
function shape_paraboloid.GetVertex(self, u, w)
	local phi = u * self.PhiMax

	local z = w*(self.ZMax-self.ZMin)
	local r = self.RadiusMax * math.sqrt(z/self.ZMax)
	local x = r * math.cos(phi)
	local y = r * math.sin(phi)

	return {x,y,z}
end




