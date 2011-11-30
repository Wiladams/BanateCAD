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
require ("cone")
require ("crayola")
require ("DisplacementSampler")
require ("GAABBox")
require ("glsl")
require ("ImageSampler")
require ("BMaterial")
require ("metaball")
require ("param_superellipse")
require ("ParamTransformer")
require ("Platonics")
require ("RubberSheet")
require ("Scene")
require ("shape_bicubicsurface")
require ("shape_disk")
require ("shape_ellipsoid")
require ("shape_hyperboloid")
require ("shape_line")
require ("shape_metaball")
require ("shape_paraboloid")
require ("shape_polyhedron")
require ("shape_torus")
require ("ShapeAnimator")
require ("STLCodec")
require ("supershape")



SceneBuilder = {}
function SceneBuilder:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end

--[[
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
--]]
--===========================
--	SHAPES
--===========================
function addshape(lshape)
	defaultscene:appendCommand(CADVM.shape(lshape))
end

function addmesh(lmesh)
	defaultscene:appendCommand(CADVM.mesh(lmesh))
end

--===========================
-- Platonic Solids
--===========================
function tetrahedron(radius)
	radius = radius or 1
	local lshape = shape_tetrahedron:new({radius=radius});

	addmesh(lshape:GetMesh())
end

function hexahedron(radius)
	radius = radius or 1
	local lshape = shape_hexahedron:new({radius=radius});

	addmesh(lshape:GetMesh())
end

function octahedron(radius)
	radius = radius or 1
	local lshape = shape_octahedron:new({radius = radius})

	addmesh(lshape:GetMesh())
end

function dodecahedron(radius)
	radius = radius or 1
	local lshape = shape_dodecahedron:new({radius = radius})

	addmesh(lshape:GetMesh())
end

function icosahedron(radius)
	radius = radius or 1
	local lshape = shape_icosahedron:new({radius = radius})

	addmesh(lshape:GetMesh())
end

--===========================
--	3D Primitives
--===========================
function line(ep1, ep2, thickness)
	thickness = thickness or 1
	defaultscene:appendCommand(CADVM.line(ep1, ep2, thickness))
end

function triangle(v1, v2, v3)
	defaultscene:appendCommand(CADVM.triangle(v1, v2, v3))
end


--===========================
--	GRAPHICS
--===========================
function aabbox(v1, v2)
	local lshape = GAABBox.new({v1,v2})

	addshape(lshape)
end

--===========================
--	MESHES
--===========================

function polyhedron(vertices, faces)
	local lshape = shape_polyhedron:new({
		vertices = vertices,
		faces = faces
		})

	addmesh(lshape:GetMesh())
end

function bicubicsurface(mesh, thickness, usteps, wsteps)
	usteps = usteps or 10
	wsteps = wsteps or 10
	local lshape = shape_bicubicsurface.new({
		M=cubic_bezier_M(),
		UMult=1,
		Mesh = mesh,
		Thickness = thickness,
		USteps = usteps,
		WSteps = wsteps})

	addshape(lshape)
end

function rubbersheet(params)
	local lshape = RubberSheet.new(params)

	addshape(lshape)
end

function import_stl(filename)
	local amesh = import_stl_mesh(filename)

	addmesh(amesh)
end

--===========================
--	Quadrics
--===========================
function sphere(radius)
	radius = radius or 1
	ellipsoid(radius, radius);
end

function ellipsoid(xradius, zradius)
xradius = xradius or 1
zradius = zradius or 1
local lshape = shape_ellipsoid.new({
	XRadius=xradius,
	ZRadius=zradius,
	USteps=360/8,
	WSteps=360/8
	})

	addshape(lshape)
end

function cone(baseradius, topradius, height, resolution)
	baseradius = baseradius or 1
	topradius = topradius or 1
	height = height or 1
	resolution = resolution or {26,10}

	local lshape = shape_cone:new({
		baseradius=baseradius,
		topradius=topradius,
		height=height,
		anglesteps=resolution[1],
		stacksteps=resolution[2]
	})

	addmesh(lshape:GetMesh())
end

function disk(radius, iradius, maxangle, resolution, offset)
	radius = radius or 1
	iradius = iradius or 0
	maxangle = maxangle or 360
	resolution = resolution or 36
	offset = offset or 0

	local lshape = shape_disk:new({
		Offset=offset,
		Radius=radius,
		InnerRadius=iradius,
		PhiMax=math.rad(maxangle),
		Resolution={resolution,2}
		})

	addmesh(lshape:GetMesh())
end

function hyperboloid(params)
	local lshape = shape_hyperboloid.new(params)

	addshape(lshape)
end

function paraboloid(params)
	local lshape = shape_paraboloid.new(params)

	addshape(lshape)
end

function torus(params)
	local lshape = shape_torus.new(params)

	addshape(lshape)
end


--===========================
--	2D Primitives
--===========================
-- Square
-- Circle
-- Polygon
-- import_dxf

--===========================
--	SUPER FORMULA
--===========================

function supershape(params)
	local lshape = shape_supershape:new({
		shape1 = superformula:new(params.shape1),
		shape2 = superformula:new(params.shape2),
		thetasteps = params.thetasteps,
		phisteps = params.phisteps})

	addmesh(lshape:GetMesh())
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

	addmesh(lshape:GetMesh())
end

--===========================
-- Transforms
--===========================
function translate(offset)
	defaultscene:appendCommand(CADVM.translate(offset))
end

function scale(ascale)
	defaultscene:appendCommand(CADVM.scale(ascale))
end

--===========================
--  Attributes
--===========================
function color(aColor)
	if type(aColor) == "table" then
		defaultscene:appendCommand(CADVM.color(aColor))
	elseif type(aColor) == "string" then
		defaultscene:appendCommand(CADVM.color(crayola.rgb(aColor)))
	end
end


