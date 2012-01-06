local class = require "pl.class"
--require "GeometricObject"
--require "ShadeRec"

class.Plane(GeometricObject)

function Plane:_init()
end

function Plane.hit(self, ray, tmin, sr)
	return false;
end
