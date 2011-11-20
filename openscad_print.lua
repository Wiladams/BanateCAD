-- openscad_print.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--


function vec2_print(v)
	io.write('[', v[1],',',v[2],']');
end

function vec3_print(f, v)
	--f:write('[', v[1],',',v[2],',',v[3],']');
	f:write(string.format("[%5.4f,%5.4f,%5.4f]", v[1],v[2],v[3]));
end

function vec3_print_tuple(v)
	io.write(v[1],',',v[2],',',v[3],'\n');
end

function vec4_print(f, v)
	f:write('[', v[1],',',v[2],',',v[3],',',v[4],']');
	--io.write("[%5.2f,%5.2f,%5.2f,%5.2f]", v[1],v[2],v[3],v[4]);
end

function mat4_print(m)
	print('[');
	vec4_print(m[1]);io.write('\n');
	vec4_print(m[2]);io.write('\n');
	vec4_print(m[3]);io.write('\n');
	vec4_print(m[4]);io.write('\n');
	print(']');
end


function matx3_print(a)
print("[");
	for i=1,#a  do
		vec3_print(a[i]);
		io.write(",\n");
	end
	print("]");
end


function matx4_print(a)
print("[");
	for i=1,#a  do
		vec4_print(a[i]);
		io.write(",\n");
	end
	print("]");
end

function table_print_indices(a)
	print("[");
	for i=1, #a do
		io.write(i-1,',');
	end
	io.write(#a);
	print("]");

end


function polygon_print(a)
	print("polygon(points=");
	print("[");
	for i=1,#a  do
		vec2_print(a[i]);
		io.write(",\n");
	end
	print("],");
	print("paths=[");
	table_print_indices(a);
	print("]);");
end

function imesh(col, row, width)
	index = ((row-1)*width)+col-1;
	return index;
end

function quad_indices_from_polymesh(width, height)
	local indices = {};

	for row =1, height-1 do
		local quadstrip = {};
		for col =1, width-1 do
			local quad = {imesh(col, row, width),imesh(col+1, row, width),
							imesh(col+1, row+1, width), imesh(col, row+1, width)};
			table.insert(indices, quad);
		end
	end

	return indices;
end

function polyhedron_print(f, pts, width, height)

	f:write("polyhedron(points=\n");
	f:write("[\n");
	for i,pt in ipairs(pts) do
		vec3_print(f, pt);
		f:write(",\n");
	end
	f:write("],\n");

	local indices = quad_indices_from_polymesh(width, height);

	f:write("triangles=[\n");
	for i,v in ipairs(indices) do
		vec4_print(f,v); f:write(',\n');
	end
	f:write("]);\n");
end


--[[
function GetBiCubicVertices(M, umult, cps, steps)

	G = cubic_vec3_to_cubic_vec4(cps);
	mat4_print(G);
	-- create a table for the results
	results = {};

	for step=0, steps  do
		local U = cubic_U(step/steps)
		local pt0 = cerp(U, M, G)

		table.insert(results, pt0);
		--vec4_print(pt0);
	end

	return results;
end
--]]

function print_face_tuple(f, a)
	local tuplen = #a
	f:write("[");
	for i=1, tuplen do
		f:write(a[i]-1);
		if i < tuplen then
			f:write(',')
		end
	end
	f:write(']');

end

function PolyMesh_print(f, mesh)
	local vertlen = #mesh.vertices
	f:write("polypoints= [\n");
	for i =1, vertlen do
		vec3_print(f, mesh.vertices[i]);
		if (i<vertlen) then
			f:write(",\n");
		end
	end
	f:write("];\n");

	local faceslen = #mesh.faces
	f:write("polytriangles=[\n");
	for i=1, faceslen do
		print_face_tuple(f, mesh.faces[i])
		if (i<faceslen) then
			f:write(',\n')
		end
	end
	f:write("];\n");

	f:write("polyhedron(points = polypoints, triangles = polytriangles);")
end
