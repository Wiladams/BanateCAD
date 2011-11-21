--
-- SceneBuilder.lua
--
-- Building scenes for FabuCAD
-- Copyright (c) 2011  William Adams
--
--[[
What makes up a scene?

Multiples of:
	mesh
	translation
	rotation

--]]
require ("CADVM")
require ("supershape")
require ("cone")
require ("shape_bicubicsurface")
require ("shape_ellipsoid")
require ("shape_polyhedron")
require ("shape_metaball")
require ("shape_torus")
require ("Platonics")
require ("crayola")
require ("metaball")


SceneBuilder = {}
function SceneBuilder:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end

defaultscene = SceneBuilder:new()

function SceneBuilder.clear(self)
	self.commands = {}
end

function SceneBuilder.appendCommand(self, aCommand)
	if (self.commands == nil) then
		self.commands = {}
	end

	table.insert(self.commands, aCommand)
end

function SceneBuilder.clearcachedobjects()
	defaultscene:appendCommand(CADVM.clearcachedobjects())
end

--===========================
-- Platonic Solids
--===========================
function tetrahedron(radius)
	radius = radius or 1
	local lshape = shape_tetrahedron:new({radius=radius});

	defaultscene:appendCommand(CADVM.mesh(lshape:GetMesh()))
end

function hexahedron(radius)
	radius = radius or 1
	local lshape = shape_hexahedron:new({radius=radius});

	defaultscene:appendCommand(CADVM.mesh(lshape:GetMesh()))
end

function octahedron(radius)
	radius = radius or 1
	local lshape = shape_octahedron:new({radius = radius})


	defaultscene:appendCommand(CADVM.mesh(lshape:GetMesh()))
end

function dodecahedron(radius)
	radius = radius or 1
	local lshape = shape_dodecahedron:new({radius = radius})


	defaultscene:appendCommand(CADVM.mesh(lshape:GetMesh()))
end

function icosahedron(radius)
	radius = radius or 1
	local lshape = shape_icosahedron:new({radius = radius})
	defaultscene:appendCommand(CADVM.mesh(lshape:GetMesh()))
end

--===========================
--	LINES
--===========================
function line(ep1, ep2, thickness)
	thickness = thickness or 1
	defaultscene:appendCommand(CADVM.line(ep1, ep2, thickness))
end

--===========================
--	MESHES
--===========================
function polyhedron(vertices, faces)
	local opolyhedron = shape_polyhedron:new({
		vertices = vertices,
		faces = faces
		})

	defaultscene:appendCommand(CADVM.mesh(opolyhedron:GetMesh()))

end

function bicubicsurface(mesh, thickness, usteps, wsteps)
	usteps = usteps or 10
	wsteps = wsteps or 10
	local lshape = shape_bicubicsurface:new({
		M=cubic_bezier_M(),
		umult=1,
		mesh = mesh,
		thickness = thickness,
		usteps = usteps,
		wsteps = wsteps})

	defaultscene:appendCommand(CADVM.mesh(lshape:GetMesh()))
end

--===========================
--	Standard Shapes
--===========================
function sphere(radius)
	radius = radius or 1
	ellipsoid(radius, radius);
end

function ellipsoid(xradius, yradius)
xradius = xradius or 1
yradius = yradius or 1
local aellipsoid = shape_ellipsoid:new({
	xradius=xradius,
	yradius=yradius,
	anglesteps=360/8,
	stacksteps=360/8
	})

	defaultscene:appendCommand(CADVM.mesh(aellipsoid:GetMesh()))
end

--[[
{offset={0,1},
	size={0.5,0.5},
	anglesteps = 12,
	stacksteps = 12}
--]]
function torus(params)
	local lshape = shape_torus:new(params)

	defaultscene:appendCommand(CADVM.mesh(lshape:GetMesh()))
end

function cone(baseradius, topradius, height, resolution)
	baseradius = baseradius or 1
	topradius = topradius or 1
	height = height or 1
	resolution = resolution or {26,10}

	local ocone = shape_cone:new({
		baseradius=baseradius,
		topradius=topradius,
		height=height,
		anglesteps=resolution[1],
		stacksteps=resolution[2]
	})

	defaultscene:appendCommand(CADVM.mesh(ocone:GetMesh()))
end

function supershape(params)
	local lshape = shape_supershape:new({
		shape1 = superformula:new(params.shape1),
		shape2 = superformula:new(params.shape2),
		thetasteps = params.thetasteps,
		phisteps = params.phisteps})

	defaultscene:appendCommand(CADVM.mesh(lshape:GetMesh()))
end

--===========================
-- Blobs
--===========================
function blobs(balls, radius, stacksteps, anglesteps)
	local lshape = shape_metaball:new({
		balls = balls,
		radius = radius,
		stacksteps = stacksteps,
		anglesteps = anglesteps,
		});

	defaultscene:appendCommand(CADVM.mesh(lshape:GetMesh()))
end

--
-- Transforms
--===========================
function translate(offset)
	defaultscene:appendCommand(CADVM.translate(offset))
end

--  Attributes
function color(aColor)
	if type(aColor) == "table" then
		defaultscene:appendCommand(CADVM.color(aColor))
	elseif type(aColor) == "string" then
		defaultscene:appendCommand(CADVM.color(crayola.rgb(aColor)))
	end
end

function scale(ascale)
	defaultscene:appendCommand(CADVM.scale(ascale))
end
