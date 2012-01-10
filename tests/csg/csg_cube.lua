require "Class"

--[[
// Construct an axis-aligned solid cube. Optional parameters are `center` and
// `radius`, which default to `[0, 0, 0]` and `1`.
//
// Example code:
//
//     var cube = CSG.cube({
//       center: [0, 0, 0],
//       radius: 1
//     });
--]]

require ("bit")
local band = bit.band

function bb(a)
	return a ~= nil and a ~= 0
end

cube = inheritsFrom(nil)

function cube.new(options)
	local new_inst = cube.create({})
	new_inst.options = options or {}
	local c = Vector.new(options.center or {0, 0, 0})
	local r = options.radius or 1

	-- start with basic geometry
	local geometry = {
		{{0, 4, 6, 2}, {-1, 0, 0}},
		{{1, 3, 7, 5}, {+1, 0, 0}},
		{{0, 1, 5, 4}, {0, -1, 0}},
		{{2, 6, 7, 3}, {0, +1, 0}},
		{{0, 2, 3, 1}, {0, 0, -1}},
		{{4, 5, 7, 6}, {0, 0, +1}}
		}


		return new CSG.Polygon(info[0].map(function(i) {
      local pos = Vector.new(
        c.x + r * (2 * bb(band(i, 1)) - 1),
        c.y + r * (2 * bb(band(i, 2)) - 1),
        c.z + r * (2 * bb(band(i, 4)) - 1)
      )

      return new Vertex.new(pos, Vector.new(info[1]));
    end))
  end))

	local polygons
	return CSG.fromPolygons

	return new_inst
end
