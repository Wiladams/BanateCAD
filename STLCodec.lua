--
-- STLCodec.lua
--
-- Copyright (c) 2011  William Adams
--
-- STL Coder and Decoder
--

require ("trimesh")
require ("test_lpeg")
require ("Class")

--
-- Construct like this
--	filehandle = io.open(filename, "w+")
--    writer = STLASCIIWriter:new({file = filehandle})
--    writer.WriteMesh(trimesh, solidname)
STLASCIIWriter = inheritsFrom(nil);
function STLASCIIWriter.new(params)
	params = params or {}		-- create object if user does not provide one

	local new_inst = STLASCIIWriter.create()

	--new_inst:Init(params)
	new_inst.file = params.file

	return new_inst
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
STLASCIIReader={}
function STLASCIIReader:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
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
