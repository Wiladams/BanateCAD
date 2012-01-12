-- shape_paraboloid.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--


-- ZMin
-- ZMax
-- RadiusMax
--

--require ("BiParametric")
local class = require "pl.class"

class.shape_paraboloid(BiParametric)
function shape_paraboloid:_init(params)
	params = params or {}

	self:super(params)

	-- Get our specifics out of the parameters
	params.PhiMax = params.PhiMax or 360

	self.ZMin = params.ZMin or 0
	self.ZMax = params.ZMax or 1
	self.RadiusMax = params.RadiusMax or 1
	self.PhiMax = math.rad(params.PhiMax)
	self.Thickness = params.Thickness
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

return shape_paraboloid


