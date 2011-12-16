--[[
// Constructive Solid Geometry (CSG) is a modeling technique that uses Boolean
// operations like union and intersection to combine 3D solids. This library
// implements CSG operations on meshes elegantly and concisely using BSP trees,
// and is meant to serve as an easily understandable implementation of the
// algorithm. All edge cases involving overlapping coplanar polygons in both
// solids are correctly handled.
//
// Example usage:
//
//     var cube = CSG.cube();
//     var sphere = CSG.sphere({ radius: 1.3 });
//     var polygons = cube.subtract(sphere).toPolygons();
//
// ## Implementation Details
//
// All CSG operations are implemented in terms of two functions, `clipTo()` and
// `invert()`, which remove parts of a BSP tree inside another BSP tree and swap
// solid and empty space, respectively. To find the union of `a` and `b`, we
// want to remove everything in `a` inside `b` and everything in `b` inside `a`,
// then combine polygons from `a` and `b` into one solid:
//
//     a.clipTo(b);
//     b.clipTo(a);
//     a.build(b.allPolygons());
//
// The only tricky part is handling overlapping coplanar polygons in both trees.
// The code above keeps both copies, but we need to keep them in one tree and
// remove them in the other tree. To remove them from `b` we can clip the
// inverse of `b` against `a`. The code for union now looks like this:
//
//     a.clipTo(b);
//     b.clipTo(a);
//     b.invert();
//     b.clipTo(a);
//     b.invert();
//     a.build(b.allPolygons());
//
// Subtraction and intersection naturally follow from set operations. If
// union is `A | B`, subtraction is `A - B = ~(~A | B)` and intersection is
// `A & B = ~(~A | ~B)` where `~` is the complement operator.
//
// ## License
//
// Copyright (c) 2011 Evan Wallace (http://madebyevan.com/), under the MIT license.

// # class CSG

// Holds a binary space partition tree representing a 3D solid. Two solids can
// be combined using the `union()`, `subtract()`, and `intersect()` methods.
--]]

--require "Class"
--require "csg_node"

CSG = inheritsFrom(nil)

function CSG.new(polygons)
	new_inst = CSG:create()
	new_inst.polygons = polygons or {}

	return new_inst
end

-- Construct a CSG solid from a list of `CSG.Polygon` instances.
function CSG.fromPolygons(polygons)
	local csg = CSG.new(polygons)

	return csg;
end

function CSG.clone(this)
	local new_inst = CSG.new()
	for _,p in ipairs(this.polygons) do
		table.insert(new_inst.polygons, p:clone())
	end

    return new_inst
end

function CSG.toPolygons(this)
    return this.polygons
end

--[[
  // Return a new CSG solid representing space in either this solid or in the
  // solid `csg`. Neither this solid nor the solid `csg` are modified.
  //
  //     A.union(B)
  //
  //     +-------+            +-------+
  //     |       |            |       |
  //     |   A   |            |       |
  //     |    +--+----+   =   |       +----+
  //     +----+--+    |       +----+       |
  //          |   B   |            |       |
  //          |       |            |       |
  //          +-------+            +-------+
  //
--]]

function CSG.union(this, csg)
    local a = Node.new(this:clone().polygons);
    local b = Node.new(csg:clone().polygons);
    a:clipTo(b);
    b:clipTo(a);
    b:invert();
    b:clipTo(a);
    b:invert();
    a:build(b:allPolygons());

    return CSG.fromPolygons(a:allPolygons())
end

--[[
  // Return a new CSG solid representing space in this solid but not in the
  // solid `csg`. Neither this solid nor the solid `csg` are modified.
  //
  //     A.subtract(B)
  //
  //     +-------+            +-------+
  //     |       |            |       |
  //     |   A   |            |       |
  //     |    +--+----+   =   |    +--+
  //     +----+--+    |       +----+
  //          |   B   |
  //          |       |
  //          +-------+
  //
--]]

function CSG.subtract(this, csg)
	local a = Node.new(this:clone().polygons);
	local b = Node.new(csg:clone().polygons);
    a:invert();
    a:clipTo(b);
    b:clipTo(a);
    b:invert();
    b:clipTo(a);
    b:invert();
    a:build(b:allPolygons());
    a:invert()

    return CSG.fromPolygons(a:allPolygons())
end

--[[
  // Return a new CSG solid representing space both this solid and in the
  // solid `csg`. Neither this solid nor the solid `csg` are modified.
  //
  //     A.intersect(B)
  //
  //     +-------+
  //     |       |
  //     |   A   |
  //     |    +--+----+   =   +--+
  //     +----+--+    |       +--+
  //          |   B   |
  //          |       |
  //          +-------+
  //
--]]

function CSG.intersect(this, csg)
    local a = Node.new(this:clone().polygons);
    local b = Node.new(csg:clone().polygons);
    a:invert();
    b:clipTo(a);
    b:invert();
    a:clipTo(b);
    b:clipTo(a);
    a:build(b:allPolygons());
    a:invert();

	return CSG.fromPolygons(a:allPolygons());
end

-- Return a new CSG solid with solid and empty space switched. This solid is
-- not modified.
function CSG.inverse(this)
	local csg = this:clone();

	for i = 1, #csg.polygons do
		csg.polygons[i] = csg.polygons[i]:flip()
	end

    return csg;
end
