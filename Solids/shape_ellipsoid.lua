-- shape_ellipsoid.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--

require "BiParametric"

local class = require "pl.class"
class.shape_ellipsoid(BiParametric)

function shape_ellipsoid:_init(params)
	params = params or {}

	self:super(params)

	-- Get our specifics out of the parameters
	self.XRadius = params.XRadius or 1
	self.ZRadius = params.ZRadius or 1
	self.MaxTheta = params.MaxTheta or 2*math.pi
	self.MaxPhi = params.MaxPhi or math.pi

end

function shape_ellipsoid.GetProfileVertex(self, u)
	local angle = u*self.MaxTheta
	local x = self.XRadius*math.sin(angle)
	local y = self.XRadius*math.sin(angle)
	local z = self.ZRadius*math.cos(angle)

	return {x,y,z}
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

function shape_ellipsoid.__tostring(self)
	return "shape_ellipsoid({XRadius = "..self.XRadius..", ZRadius ="..self.ZRadius..'})'
end

--[[
local se = shape_ellipsoid({XRadius = 1, ZRadius = 1, MaxTheta = 360, MaxPhi = 180})
print(se)
--]]

return shape_ellipsoid

