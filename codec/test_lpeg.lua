-- test_lpeg.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
-- This should be a part of the STLCodec
--
local m=require("lpeg")
--require ("trimesh")

P = m.P
R = m.R
S = m.S
C = m.C
match = m.match

local any = m.P(1)
local HWS = m.S("\t\r\n\f ")^1	-- White space must exist
local OPT_WS = m.S"\t\r\n\f "^0	-- Optional whitespace


local digit = R('09')
local number_sign = S'+-'^-1
local number_float = (number_sign^-1 * digit^1 * P'.' * digit^0 + P'.' * digit^1) *
                     (S'eE' * number_sign * digit^1)^-1 * OPT_WS


local WS_FLOAT = m.P(HWS * number_float)

local COORDS = C(number_float)^3

--local SOLID = OPT_WS * P"solid" * HWS * C"OpenSCAD_Model" * OPT_WS
local SOLID = OPT_WS * P"solid" * OPT_WS
local FACET_OPEN = OPT_WS * P"facet" * HWS * P"normal" * HWS * COORDS
local OUTERLOOP = OPT_WS * P"outer" * HWS * P"loop" * OPT_WS
local VERTEX = OPT_WS * P"vertex" * HWS * COORDS
local ENDLOOP = OPT_WS * P"endloop"
local ENDFACET = OPT_WS * P"endfacet"
local ENDSOLID = OPT_WS * P"endsolid"


function parsestl(filehandle)
	local mesh = trimesh({name="stlmesh"})

	local line = filehandle:read()
	local pos = 1

	local modeler = match(SOLID, line);
	if modeler == nil then
		print("Not valid ASCII STL")
		return nil
	end


	print("Modeler: ", modeler,i);


	while true do
		-- facet normal ni  nj  nk
		line = filehandle:read()
		local ni, nj, nk = match(FACET_OPEN, line);

		if ni == nil then break end

		-- outer loop
		line = filehandle:read()
		pos = match(OUTERLOOP, line)

		-- vertex v1x v1y v1z
		line = filehandle:read()
		local v1x, v1y, v1z = match(VERTEX, line)
		v1 = mesh:addvertex({v1x, v1y, v1z})

		-- vertex v2x v2y v2z
		line = filehandle:read()
		local v2x, v2y, v2z  = match(VERTEX, line)
		v2 = mesh:addvertex({v2x, v2y, v2z})

		-- vertex v3x v3y v3z
		line = filehandle:read()
		local v3x, v3y, v3z  = match(VERTEX, line)
		v3 = mesh:addvertex({v3x, v3y, v3z})


		-- endloop
		line = filehandle:read()
		pos = match(ENDLOOP, line)

		-- endfacet
		line = filehandle:read()
		pos = match(ENDFACET, line)

		mesh:addface({v1,v2,v3})
	end

	return mesh;
end
