function createFacet(vertices)
	local face={}
	local verts = {}

--print("Vertices: ", #vertices)
	for i,v in ipairs(vertices) do
		local avert = {v.pos.x, v.pos.y, v.pos.z}
		table.insert(verts, avert)
		table.insert(face, i)
	end

	local apoly = shape_polyhedron:new({
		vertices = verts,
		faces = {face}
		})

	return apoly
end

function displayPolygons(polygons, c)
	for _,polygon in ipairs(polygons) do
		local apolyhedra = createFacet(polygon.vertices)
		color(c)
		addmesh(apolyhedra:GetMesh())
	end

end

local cyl1 = csg_cylinder.new({
	start={0,0,-2},
	ending={0,0,2},
	slices=32,
	radius = 0.75,
	});

--displayPolygons(cyl1:toPolygons(), crayola.rgb("Blue"))

local cyl2 = csg_cylinder.new({
	start={0,-2,0},
	ending={0,2,0},
	slices=32,
	});

--displayPolygons(cyl2:toPolygons(), crayola.rgb("Blue"))

local cyl3 = csg_cylinder.new({
	start={0,2,0},
	ending={0,4,0},
	slices=32,
	});

--displayPolygons(cyl3:toPolygons(), crayola.rgb("Red"))

--local cyl_union = cyl1:union(cyl2)
--displayPolygons(cyl_union:toPolygons(), crayola.rgb("Yellow"))


--local cyl_sub = cyl1:subtract(cyl2)
--displayPolygons(cyl_sub:toPolygons(), crayola.rgb("Yellow"))

local cyl_intersect = cyl2:intersect(cyl1)
displayPolygons(cyl_intersect:toPolygons(), crayola.rgb("Yellow"))



local asphere = csg_sphere.new({
	radius= 2,
	slices=16,
	stacks = 16,
	});


--local subtracted = cyl1:subtract(asphere)
--local unioned = asphere:union(cyl2)
--local intersected = asphere:intersect(cyl3)

-- First Display the sphere
--displayPolygons(asphere:toPolygons(), crayola.rgb("Red"))

--displayPolygons(subtracted:toPolygons(), crayola.rgb("Yellow"))

--displayPolygons(unioned:toPolygons(), crayola.rgb("Yellow"))

--displayPolygons(intersected:toPolygons(), crayola.rgb("Yellow"))