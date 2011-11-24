-- shape_ellipsoid.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
require ("trimesh")
require ("Shape")
require ("BiParametric")

-- xradius
-- yradius
-- WSteps
-- USteps
-- name
--
shape_ellipsoid = inheritsFrom(BiParametric)
function shape_ellipsoid.new(params)
	local new_inst = shape_ellipsoid.create()
	new_inst:Init(params)

	return new_inst
end

-- USteps
-- WSteps
-- XRadius
-- YRadius
function shape_ellipsoid.Init(self, params)
	params = params or {}

	-- Allow the base class to pull out what it wants
	--self:superClass():Init(params)
	self.USteps = params.USteps or 10
	self.WSteps = params.WSteps or 10
	self.ColorSampler = params.ColorSampler or nil

	-- Get our specifics out of the parameters
	self.XRadius = params.XRadius or 1
	self.YRadius = params.YRadius or 1

	return self
end


-- Given parametric u, and v, return coordinates
-- on the surface of the ellipsoid
function shape_ellipsoid.GetVertex(self, u, w)
	theta = u * 2*math.pi
	phi = w * math.pi

	return {
		self.XRadius*math.cos(theta),
		self.YRadius*math.sin(theta)*math.cos(phi),
		self.YRadius*math.sin(theta)*math.sin(phi)};
end




