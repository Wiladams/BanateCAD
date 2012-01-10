function test_cubic_vertices()
	cpts = {{0, 1, 0},{2,3,0}, {4,1,0},{5,2,0}};
	cptsh = {{0, 1, 0,1},{2,3,0,1}, {4,1,0,1},{5,2,0,1}};

--u1 = cubic_U(0.5);
--g = cubic_vec3_to_cubic_vec4(cps);

--vec4_print(u1);
--mat4_print(cubic_bezier_M());

--pt0 = ccerp(u1, cubic_bezier_M(), cptsh)

--vec4_print(pt0);

--points = IterateBiCubicVertices(cubic_bezier_M(), 1, cpts, 10);
--polygon_print(points);

	points = {};

	for v in IterateCubicVertices(cubic_bezier_M(), 1, cptsh, 10) do
		table.insert(points,v);
	end

	polygon_print(points);
end

function getpolymesh(M, umult, mesh, usteps, wsteps)

	local thickness = 1;
	local vertices = {};
	local innerverts = {};
	local normals = {};

	for w=0, wsteps do
		for u=0, usteps do
			local svert, normal = bicerp(u/usteps, w/wsteps, mesh, M, 1);
			table.insert(vertices, svert);
			table.insert(normals, normal);

			local ivert = vec3_add(svert, vec3_mults(normal,thickness));
			table.insert(innerverts, ivert);
		end
	end


	return vertices, normals, innerverts;
end

function displaymesh(verts, iverts)
	color({0,1,0,1})
	for _,v in ipairs(verts) do
		--print("V -> ", type(v))
		--print(v[1])
		--vec3_print_tuple(v)
		translate(v)
		tetrahedron(0.5)
	end

	color({1,0,0,1})
	for _,v in ipairs(iverts) do
		translate(v)
		tetrahedron(0.5)
	end
end

function bicubicsurface(mesh, usteps, wsteps)

	local verts, norms, iverts = getpolymesh(cubic_bezier_M(), 1,
			mesh, usteps, wsteps);

	displaymesh(verts, iverts)
end

function test_bicubic_vertices()
	resolution = {48, 48}	-- Determines how many "columns" and "rows" 
						-- will be used to sample the curve

	-- This curve actually shows a flaw with respect to the normals
	-- When you try to print it as a solid, you will get a wrong result
	-- Notice how the green crosses the red in certain positions
	local gcp4 = {{0,30,0,1}, {10,40,0,1}, {20,40,0,1}, {30,30,0,1}};
	local gcp3 = {{5,20,10,1}, {10,20,20,1}, {15,25,15,1}, {20,20,5,1}};
	local gcp2 = {{5,10,10,1}, {10,10,20,1}, {15,5,15,1}, {20,10,5,1}};
	local gcp1 = {{0,0,0,1}, {10,-10,0,1}, {20,-10,0,1}, {30,0,0,1}};

	bicubicsurface({gcp1, gcp2, gcp3, gcp4}, resolution[1], resolution[2])
end

function test_heel()
	local hh=60;

	local fcp4 = {{0,-20,hh,1},{30,-20,hh+10,1}, {30,20,hh+10,1}, {0,20,hh,1}}; 
	local fcp3 = {{0,-20,50,1}, {30,-20,60,1}, {30,20,60,1}, {0,20,50,1}}; 
	local fcp2 = {{0,-1,40,1}, {10,-1,40,1}, {10,1,40,1}, {0,1,40,1}}; 
	local fcp1 = {{0,-1,0,1}, {10,-1,0,1}, {10,1,0,1}, {0,1,0,1}}; 

	bicubicsurface({fcp1, fcp2, fcp3, fcp4}, 48, 96)

end

-- Running Tests
test_bicubic_vertices();
--test_heel();