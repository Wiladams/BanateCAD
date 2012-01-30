--
-- STLCodec.lua
--
-- Copyright (c) 2011  William Adams
--
-- STL Coder and Decoder
--

require ("test_lpeg")
local class = require "pl.class"

--
-- Construct like this
--	filehandle = io.open(filename, "w+")
--    writer = STLASCIIWriter:new({file = filehandle})
--    writer.WriteMesh(trimesh, solidname)
class.STLASCIIWriter()

function STLASCIIWriter:_init(params)
	params = params or {}		-- create object if user does not provide one

	self.file = params.file
end



function STLASCIIWriter.WriteMesh(self, mesh, solidname)
	self.file:write(string.format('solid %s\n',solidname));

	for i=1,#mesh.faces  do
		local face = mesh.faces[i]
		local tri = {mesh.vertices[face[1]], mesh.vertices[face[2]], mesh.vertices[face[3]]}

		self:WriteFace(tri, face.normal);
	end

	self.file:write(string.format("endsolid %s\n", solidname));
end

function STLASCIIWriter.WriteFace(self, facet, normal)
	-- calculate the facet normal
	local fnormal = {0,0,0};

	-- header
	self.file:write('facet normal  0 0 0\n');
	self.file:write('outer loop\n');

	-- print vertices
	self:WriteSTLVertex(facet[1]);
	self:WriteSTLVertex(facet[2]);
	self:WriteSTLVertex(facet[3]);

	-- footer
	self.file:write('endloop\n');
	self.file:write('endfacet\n');
end

function STLASCIIWriter.WriteSTLVertex(self, v)
	self.file:write(string.format("vertex %5.4f %5.4f %5.4f\n", v[1],v[2],v[3]));
end







-- Construct like this
--	filehandle = io.open(filename, "r")
--    reader = STLASCIIReader:new({file = filehandle})
--    trimesh = reader.Read()
class.STLASCIIReader()
function STLASCIIReader:_init(params)
	params = params or {}		-- create object if user does not provide one

	self.file = params.file
end


function STLASCIIReader.Read(self)

local amesh = parsestl(self.file);

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

function import_stl_mesh(filename)
	local filehandle = io.open(filename, 'r')

	local reader = STLASCIIReader:new({file = filehandle});
	local tmesh = reader:Read();

	-- close the file
	filehandle:close()

	return tmesh

end
