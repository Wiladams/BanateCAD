local class = require "pl.class"

class.GeometricObject()

function GeometricObject:_init()
end

function GeometricObject.hit(self, ray, tmin, sr)
	return false;
end


return GeometricObject
