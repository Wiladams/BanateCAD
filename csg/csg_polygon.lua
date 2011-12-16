
--[[
// # class Polygon

// Represents a convex polygon. The vertices used to initialize a polygon must
// be coplanar and form a convex loop. They do not have to be `CSG.Vertex`
// instances but they must behave similarly (duck typing can be used for
// customization).
//
// Each convex polygon has a `shared` property, which is shared between all
// polygons that are clones of each other or were split from the same polygon.
// This can be used to define per-polygon properties (such as surface color).
--]]

--require "Class"
--require "csg_plane"

Polygon = inheritsFrom(nil)

function Polygon.new(vertices, shared)
	local this = Polygon:create()
	this.vertices = vertices;
	this.shared = shared or false;

	this.plane = Plane.fromPoints(vertices[1].pos, vertices[2].pos, vertices[3].pos);

	return this
end

function Polygon.clone(this)
    local vertices = {}

	for _,v in ipairs(this.vertices) do
		table.insert(vertices, v:clone())
	end

    return Polygon.new(vertices, this.shared)
end

function Polygon.flip(this)
	for i=1,#this.vertices do
		this.vertices[i]:flip()
	end
    this.plane:flip()

	return this
end

function Polygon.print(this)
	print("Polygon")
	for _,v in ipairs(this.vertices) do
		print(v:tostring())
	end
end
