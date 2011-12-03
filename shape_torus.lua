-- shape_torus.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--

--require ("trimesh")
require ("BiParametric")
require ("checkerboard")
--require ("maths")

shape_torus = inheritsFrom(BiParametric)
function shape_torus.new(params)
	local new_inst = shape_torus.create()

	new_inst:Init(params)

	return new_inst
end


-- USteps
-- WSteps
-- Offset
-- Size
function alerp( a1, a2, u)
	return a1 + u*(a2-a1)
end

function shape_torus.Init(self, params)
	params = params or {}

	--self:superClass():Init(params)
	self.USteps = params.USteps or 10
	self.WSteps = params.WSteps or 10
	self.ColorSampler = params.ColorSampler or nil
	self.VertexFunction = params.VertexFunction or nil
	self.Thickness = params.Thickness or nil

	self.HoleRadius = params.HoleRadius or 1
	self.ProfileRadius = params.ProfileRadius or 1

	self.ColorSampler = params.ColorSampler or nil
	self.ProfileSampler = params.ProfileSampler or nil

	self.MinTheta = params.MinTheta or 0
	self.MaxTheta = params.MaxTheta or 2*math.pi
	self.MinPhi = params.MinPhi or 0
	self.MaxPhi = params.MaxPhi or 2*math.pi

	return self
end

-- Should be an x,z value
function shape_torus.GetProfileVertex(self, u)

	local thetaangle = alerp(self.MinTheta, self.MaxTheta, u)
	u = thetaangle/self.MaxTheta

	if self.ProfileSampler ~= nil then
		-- Get the profile
		local profilept = self.ProfileSampler:GetProfileVertex(u)

		-- Add the appropriate offset
		local x = self.HoleRadius+profilept[1]
		local y = self.HoleRadius+profilept[2]
		local z = profilept[3]

		return {x,y,z}
	end

	-- If we don't have a profile generator
	-- Assume the profile should be a sphere
	local angle = alerp(self.MinTheta, self.MaxTheta, u)
	local x = (self.HoleRadius+self.ProfileRadius*math.sin(angle))
	local y = (self.HoleRadius+self.ProfileRadius*math.sin(angle))
	local z = self.ProfileRadius*math.cos(angle)

	return {x,y,z}
end

function shape_torus.GetVertex(self, u, v)
	local phi = alerp(self.MinPhi, self.MaxPhi, v)


	local profilept, normal = self:GetProfileVertex(u)

	local x = profilept[1]*math.cos(phi)
	local y = profilept[2]*math.sin(phi)
	local z = profilept[3]

	local pt = {x,y,z}

	return pt;
end

