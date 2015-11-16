local class = require "pl.class"
local GeometricObject = require "GeometricObject"

class.Plane(GeometricObject)

function Plane:_init()
end

function Plane.hit(self, ray, tmin, sr)
	return false;
end
