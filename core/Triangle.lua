local class = require "pl.class"

require "GeometricObject"
require "glsl"

class.Triangle(GeometricObject)

function Triangle:_init(...)
	self.v0 = Point3D(0,0,0)
	self.v1 = Point3D(1,0,0)
	self.v2 = Point3D(0,1,0)

	if arg.n == 0 then
	elseif arg.n == 3 then
		self.v0 = Point3D(arg[1])
		self.v1 = Point3D(arg[2])
		self.v2 = Point3D(arg[3])
	end

	local vec1 = v1 - v0
	local vec2 = v2 - v0

	self.normal = cross(vec2, vec1):normalize()
end
