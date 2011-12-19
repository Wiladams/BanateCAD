--[[

// Construct a solid cylinder. Optional parameters are `start`, `end`,
// `radius`, and `slices`, which default to `[0, -1, 0]`, `[0, 1, 0]`, `1`, and
// `16`. The `slices` parameter controls the tessellation.
//
// Example usage:
//
//     var cylinder = CSG.cylinder({
//       start: [0, -1, 0],
//       end: [0, 1, 0],
//       radius: 1,
//       slices: 16
//     });
--]]

--require ("Class")
--require ("csg_vector")
--require ("csg_vertex")
--require ("csg_polygon")
--require ("csg_ops")

function lognum(a)
	if a then return 1 else return 0 end
end

csg_cylinder = {}

function csg_cylinder.new(options)
	options = options or {};
	options.start = options.start or {0, -1, 0}
	options.ending = options.ending or {0, 1, 0}
	options.radius = options.radius or 1
	options.slices = options.slices or 16

	local s = Vector3D.new(options.start);
	local e = Vector3D.new(options.ending);
	local ray = e - s;

	local r = options.radius
	local slices = options.slices
	local axisZ = ray:unit()
	local isY = (math.abs(axisZ.y) > 0.5);
	local axisX = Vector3D.new(lognum(isY), lognum(not isY), 0):cross(axisZ):unit();
	local axisY = axisX:cross(axisZ):unit();
	local start = Vertex.new(s, -axisZ);
	local ending = Vertex.new(e, axisZ:unit());

	local polygons = {}

  function GetVertex(stack, slice, normalBlend)
    local angle = slice * math.pi * 2;
    local out = (axisX * math.cos(angle)) + (axisY *math.sin(angle));
    local pos = s + (ray * stack) + (out * r);
    local normal = out * (1 - math.abs(normalBlend)) + (axisZ *normalBlend);

	return Vertex.new(pos, normal);
  end

	for i = 0, slices-1 do
		local t0 = i / slices
		local t1 = (i + 1) / slices

		-- For each slice, create a bottom, side, and top
		table.insert(polygons, Polygon.new({start, GetVertex(0, t1, -1), GetVertex(0, t0, -1)}))
		table.insert(polygons, Polygon.new({GetVertex(0, t0, 0), GetVertex(0, t1, 0), GetVertex(1, t1, 0), GetVertex(1, t0, 0) }))
		table.insert(polygons, Polygon.new({ending, GetVertex(1, t0, 1), GetVertex(1, t1, 1)}))
	end

	return CSG.fromPolygons(polygons);
end



--[[
local acyl = csg_cylinder.new()
--]]
