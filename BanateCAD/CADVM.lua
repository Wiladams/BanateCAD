-- CADVM.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--

CADVM =
{
	CLEARCACHEDOBJECTS  = 1,
	TRANSLATION = 16,
	ROTATION = 17,
	SCALE = 18,
	COLOR = 19,

	SHAPE = 128,
	POINT = 129,
	LINE = 130,
	TRIANGLE = 131,
	QUAD = 132,
	ELLIPSE = 133,
	TRIMESH = 134,
	MESH = 135,
	DISPATCHER = 136,
}

-- The Rendering System
function CADVM.clearcachedobjects()
	return {command = CADVM.CLEARCACHEDOBJECTS, value = nil}
end

-- Transformation
function CADVM.translate(trans)
	return {command = CADVM.TRANSLATION, value = trans}
end

function CADVM.rotate(angle, x, y, z)
	return {command = CADVM.ROTATION, value = {angle=angle, axis={x,y,z}}}
end

function CADVM.scale(ascale)
	return {command = CADVM.SCALE, value = ascale}
end




-- Drawing Attributes
function CADVM.color(aColor)
	return {command = CADVM.COLOR, value = aColor}
end




-- Shapes
function CADVM.shape(ashape)
	return {command = CADVM.SHAPE, value = ashape}
end

function CADVM.mesh(amesh)
	return {command = CADVM.TRIMESH, value = amesh}
end

function CADVM.line(ep1, ep2, thickness)
	return {command = CADVM.LINE, value = {ep1, ep2, thickness}}
end

function CADVM.triangle(v1, v2, v3)
	return {command = CADVM.TRIANGLE, value = {v1, v2, v3}}
end
