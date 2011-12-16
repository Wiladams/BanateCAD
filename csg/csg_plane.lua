

-- # class Plane

-- Represents a plane in 3D space.
--require ("Class")
local bit = require ("bit")
--require ("csg_vector")

local bor = bit.bor

Plane = inheritsFrom(nil)

--`CSG.Plane.EPSILON` is the tolerance used by `splitPolygon()` to decide if a
-- point is on the plane.
Plane.EPSILON = 1e-5;

function Plane.new(normal, w)
	local this = Plane:create()
	this.normal = normal
	this.w = w

	return this
end


function Plane.fromPoints(a, b, c)
  local n = ((b-a):cross(c - a)):unit();
  return Plane.new(n, n:dot(a));
end

function Plane.clone(this)
    return Plane.new(this.normal:clone(), this.w);
end

function Plane.flip(this)
    this.normal = -this.normal;
    this.w = -this.w;

	return this
end

--[[
  // Split `polygon` by this plane if needed, then put the polygon or polygon
  // fragments in the appropriate lists. Coplanar polygons go into either
  // `coplanarFront` or `coplanarBack` depending on their orientation with
  // respect to this plane. Polygons in front or in back of this plane go into
  // either `front` or `back`.
--]]
function Plane.splitPolygon(this, polygon, coplanarFront, coplanarBack, front, back)
    local COPLANAR = 0;
    local FRONT = 1;
    local BACK = 2;
    local SPANNING = 3;

    -- Classify each point as well as the entire polygon into one of the above
    -- four classes.
    local polygonType = 0;
    local types = {};

    for i = 1, #polygon.vertices do
		local t = this.normal:dot(polygon.vertices[i].pos) - this.w;
		local ptype = COPLANAR
		if t < -Plane.EPSILON then
			ptype = BACK
		elseif t > Plane.EPSILON then
			ptype = FRONT
		else
			ptype = COPLANAR
		end

		polygonType = bit.bor(polygonType, ptype)

		table.insert(types,ptype);
    end

    -- Put the polygon in the correct list, splitting it when necessary.
    if polygonType == COPLANAR then
        if this.normal:dot(polygon.plane.normal) > 0  then
			table.insert(coplanarFront, polygon)
		else
			table.insert(coplanarBack,polygon)
		end
	elseif polygonType == FRONT then
        table.insert(front,polygon);
	elseif polygonType == BACK then
        table.insert(back,polygon);
	elseif polygonType == SPANNING then
        local f = {}
		local b = {}

--print("Polygon.vertices# ", #polygon.vertices)
        for i = 1, #polygon.vertices do
			local j = (i % #polygon.vertices) +1

--print("vert: ", polygon.vertices[i]:tostring())
			-- Types of current vertex and next one
			local ti = types[i]
			local tj = types[j]

			-- Vertices of current and next one
			local vi = polygon.vertices[i]
			local vj = polygon.vertices[j]

			if (ti ~= BACK) then
				table.insert(f,vi);
			end


			if (ti ~= FRONT) then
				if ti ~= BACK then
					table.insert(b, vi:clone())
				else
					table.insert(b, vi)
				end
			end

			if bit.bor(ti, tj) == SPANNING then
				local t = (this.w - this.normal:dot(vi.pos)) / this.normal:dot(vj.pos - vi.pos);
				local v = vi:interpolate(vj, t);
				table.insert(f,v);
				table.insert(b,v:clone());
			end
        end

        if (#f >= 3) then
			table.insert(front, Polygon.new(f, polygon.shared));
        end

		if (#b >= 3) then
			table.insert(back, Polygon.new(b, polygon.shared));
        end
    end
end



function Plane.tostring(this)
	print("Plane: ", this.normal:tostring(), this.w)
end
