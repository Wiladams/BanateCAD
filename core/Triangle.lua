local class = require "pl.class"

local GeometricObject = require("GeometricObject")
local glsl = require("glsl")

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

function Triangle.AreColinear(p,q,r)
	local cr = cross((q - p),(r - p))
--print(cr[1], cr[2], cr[3])
	return not any(cr)
end

-- test if a point lies inside of a triangle using cramers rule
function Triangle.Contains(q, p1,p2,p3)
	local v1,v2 = p2 - p1, p3 - p1
	local qp = q - p1
	local dv = v1:cross(v2)
	local l = qp:cross(v2)

	if l <= 0 then
		return false
	end
	local m = v1:cross(qp)

	if m <= 0 then
		return false
	end

	return (l+m)/dv < 1
end

--[[
	local col1 = Triangle.AreColinear(vec3(0,0,0), vec3(10,0,0), vec3(20,0,0))
	print(col1);

	local col2 = Triangle.AreColinear(vec3(0,0,0), vec3(10,10,0), vec3(20,0,0))
	print(col2);
--]]
