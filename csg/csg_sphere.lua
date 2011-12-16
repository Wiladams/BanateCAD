
--[[
// Construct a solid sphere. Optional parameters are `center`, `radius`,
// `slices`, and `stacks`, which default to `[0, 0, 0]`, `1`, `16`, and `8`.
// The `slices` and `stacks` parameters control the tessellation along the
// longitude and latitude directions.
//
//
// Example usage:
//
//     var sphere = CSG.sphere({
//       center: [0, 0, 0],
//       radius: 1,
//       slices: 16,
//       stacks: 8
//     });
--]]

--require("Class")

csg_sphere = inheritsFrom(nil)

function csg_sphere.new(options)
	options = options or {};
	local c = Vector3D.new(options.center or {0, 0, 0});
	local r = options.radius or 1;
	local slices = options.slices or 16;
	local stacks = options.stacks or 8;
	local polygons = {}
	local vertices={};

	function GetVertex(u, w)
		local theta = u*math.pi * 2;
		local phi = w*math.pi;
		local  dir = Vector3D.new(
			math.cos(theta) * math.sin(phi),
			math.cos(phi),
			math.sin(theta) * math.sin(phi)
			)
		table.insert(vertices, Vertex.new(c + (dir * r), dir))
	end

	for i = 0, slices-1 do
		for j = 0, stacks-1 do
			vertices = {}
			GetVertex(i / slices, j / stacks);


			if (j < stacks - 1) then
				GetVertex(i / slices, (j + 1) / stacks);
			end

			GetVertex((i + 1) / slices, (j + 1) / stacks);

			-- If we're not at a pole
			-- then create a quad
			if (j > 0) then
				GetVertex((i + 1) / slices, j / stacks);
			end

			-- Add a new polygon to the list of polygons
			table.insert(polygons, Polygon.new(vertices));
		end
	end

	return CSG.fromPolygons(polygons);
end
