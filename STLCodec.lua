--
-- STLCodec.lua
--
-- Copyright (c) 2011  William Adams
--
-- STL Coder and Decoder
--

require ("trimesh")
require ("test_lpeg")

--
-- Construct like this
--	filehandle = io.open(filename, "w+")
--    writer = STLASCIIWriter:new({file = filehandle})
--    writer.WriteMesh(trimesh)
STLASCIIWriter={}
function STLASCIIWriter:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end

function STLASCIIWriter.WriteMesh(self, mesh, solidname)
	file:write(string.format('solid %s\n',solidname));

	for i=1,#mesh.faces  do
		local face = mesh.faces[i]
		local tri = {mesh.vertices[face[1]], mesh.vertices[face[2]], mesh.vertices[face[3]]}

		self.WriteFace(tri, face.normal);
	end

	io.write(string.format("endsolid %s\n", name));
end

function STLASCIIWriter.WriteFace(self, facet, normal)
	-- calculate the facet normal
	local fnormal = {0,0,0};

	-- header
	io.write('facet normal  0 0\n');
	io.write('outer loop\n');

	-- print vertices
	writeASCIISTLVertex(facet[1]);
	writeASCIISTLVertex(facet[2]);
	writeASCIISTLVertex(facet[3]);

	-- footer
	io.write('endloop\n');
	io.write('endfacet\n');
end

function STLASCIIWriter.writeSTLVertex(self, v)
	io.write(string.format("vertex %5.4f %5.4f %5.4f\n", v[1],v[2],v[3]));
end







-- Construct like this
--	filehandle = io.open(filename, "r")
--    reader = STLASCIIReader:new({file = filehandle})
--    trimesh = reader.Read()
STLASCIIReader={}
function STLASCIIReader:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end


function STLASCIIReader.Read(self)

amesh = parsestl(self.file);

	--[[
	-- Process the text one line at a time
	-- Read all the text into a string
	local t = self.file:read("*all")
	for line in t:gmatch("[^\r\n]+") do
		io.write(line)
	end
--]]
	return amesh
end

function STLASCIIWriter.WriteFace(self, facet, normal)
	-- calculate the facet normal
	local fnormal = {0,0,0};

	-- header
	io.write('facet normal  0 0\n');
	io.write('outer loop\n');

	-- print vertices
	writeASCIISTLVertex(facet[1]);
	writeASCIISTLVertex(facet[2]);
	writeASCIISTLVertex(facet[3]);

	-- footer
	io.write('endloop\n');
	io.write('endfacet\n');
end

function STLASCIIWriter.writeSTLVertex(self, v)
	io.write(string.format("vertex %5.4f %5.4f %5.4f\n", v[1],v[2],v[3]));
end
