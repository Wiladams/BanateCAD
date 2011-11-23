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
-- Create the prototypical cone
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

	self.USteps = params.USteps or 10
	self.WSteps = params.WSteps or 10
	self.XRadius = params.XRadius or 1
	self.YRadius = params.YRadius or 1

	self.ParamFunction = self

	return self
end


-- Given parametric u, and v, return coordinates
-- on the surface of the ellipsoid
function shape_ellipsoid.GetValue(self, u, v)
	theta = u * 2*math.pi
	phi = v * math.pi

	return {
		self.XRadius*math.cos(theta),
		self.YRadius*math.sin(theta)*math.cos(phi),
		self.YRadius*math.sin(theta)*math.sin(phi)};
end




