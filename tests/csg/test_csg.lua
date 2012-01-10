require "csg_cylinder"
require "csg_sphere"
require "csg_ops"
local bit = require "bit"


local acylinder = cylinder.new();
local asphere = sphere.new({ radius= 1.3 });

--print("asphere: ", asphere)
--print("acylinder: ", acylinder)

local sub = asphere:subtract(acylinder)

--print("sub: ", sub)

local polygons = sub:toPolygons()

for _,polygon in ipairs(polygons) do
	for i=1, #polygon.vertices do
		print(polygon.vertices[i]:tostring())
	end
end
