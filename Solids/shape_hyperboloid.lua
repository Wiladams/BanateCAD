-- shape_hyperboloid.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
--require ("BiParametric")

-- ZMin
-- ZMax
-- RadiusMax
--
local class = require "pl.class"

class.shape_hyperboloid(BiParametric)

function shape_hyperboloid:_init(params)
	params = params or {}

	self:super(params)

	-- Get our specifics out of the parameters
	params.PhiMax = params.PhiMax or 360
	self.PhiMax = math.rad(params.PhiMax)

	self.StartPoint = params.StartPoint or {1,0,0}
	self.EndPoint = params.EndPoint or {1,1,1}

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

return shape_hyperboloid
