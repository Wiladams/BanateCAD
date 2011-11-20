-- CADVM.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--

function lerp1(u, p0, p1)
	return (1-u)*p0 + u*p1
end

function lerp(u, v1, v2)
	return {
		lerp1(u, v1[1], v2[1]),
		lerp1(u, v1[2], v2[2]),
		lerp1(u, v1[3], v2[3])
	}
end

CADVM =
{
	CLEARCACHEDOBJECTS  = 1,
	TRANSLATION = 16,
	ROTATION = 17,
	SCALE = 18,
	COLOR = 19,

	MESH = 128,
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
function CADVM.mesh(amesh)
	return {command = CADVM.MESH, value = amesh}
end

