-- shape_ellipsoid.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
require ("trimesh")
require ("Shape")
require ("BiParametric")

-- xradius
-- zradius
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
	self.Thickness = params.Thickness

	-- Get our specifics out of the parameters
	self.XRadius = params.XRadius or 1
	self.ZRadius = params.ZRadius or 1
	self.MaxTheta = params.MaxTheta or 2*math.pi
	self.MaxPhi = params.MaxPhi or math.pi

	return self
end


-- Given parametric u, and v, return coordinates
-- on the surface of the ellipsoid
function shape_ellipsoid.GetVertex(self, u, w)
	theta = u * self.MaxTheta
	phi = math.pi - w * self.MaxPhi

	local xr = self.XRadius*math.sin(phi)* math.cos(theta)
	local yr = self.XRadius*math.sin(phi)*math.sin(theta)
	local zr = self.ZRadius*math.cos(phi)

	local vert =  {xr, yr, zr}

	local normal = vec3_norm(vert)

	return vert, normal
end




