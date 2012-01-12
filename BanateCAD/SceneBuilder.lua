--
-- SceneBuilder.lua
--
-- Building scenes for BanateCAD
-- Copyright (c) 2011  William Adams
--
--[[
What makes up a scene?

Multiples of:
	mesh
	translation
	rotation

--]]

require "BCADLanguage"


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
	local lshape = shape_tetrahedron({radius=radius});

	addmesh(lshape:GetMesh())
end

function hexahedron(radius)
	radius = radius or 1
	local lshape = shape_hexahedron({radius=radius});

	addmesh(lshape:GetMesh())
end

function octahedron(radius)
	radius = radius or 1
	local lshape = shape_octahedron({radius = radius})

	addmesh(lshape:GetMesh())
end

function dodecahedron(radius)
	radius = radius or 1
	local lshape = shape_dodecahedron({radius = radius})

	addmesh(lshape:GetMesh())
end

function icosahedron(radius)
	radius = radius or 1
	local lshape = shape_icosahedron({radius = radius})

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
	local lshape = GAABBox({v1,v2})

	addshape(lshape)
end

--===========================
--	MESHES
--===========================

function polyhedron(vertices, faces)
	local lshape = shape_polyhedron({
		vertices = vertices,
		faces = faces
		})

	addmesh(lshape:GetMesh())
end

function bicubicsurface(mesh, thickness, usteps, wsteps)
	usteps = usteps or 10
	wsteps = wsteps or 10
	local lshape = shape_bicubicsurface({
		M=cubic_bezier_M(),
		UMult=1,
		Mesh = mesh,
		Thickness = thickness,
		USteps = usteps,
		WSteps = wsteps})

	addshape(lshape)
end

function rubbersheet(params)
	local lshape = RubberSheet(params)

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
local lshape = shape_ellipsoid({
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

	local lshape = shape_cone({
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

	local lshape = shape_disk({
		Offset=offset,
		Radius=radius,
		InnerRadius=iradius,
		PhiMax=math.rad(maxangle),
		Resolution={resolution,2}
		})

	addmesh(lshape:GetMesh())
end

function hyperboloid(params)
	local lshape = shape_hyperboloid(params)

	addshape(lshape)
end

function paraboloid(params)
	local lshape = shape_paraboloid(params)

	addshape(lshape)
end

function torus(params)
	local lshape = shape_torus(params)

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
	local lshape = shape_supershape({
		shape1 = superformula(params.shape1),
		shape2 = superformula(params.shape2),
		thetasteps = params.thetasteps,
		phisteps = params.phisteps})

	addmesh(lshape:GetMesh())
end

--===========================
-- Blobs
--===========================
function blobs(balls, radius, stacksteps, anglesteps)
	local lshape = shape_metaball({
		balls = balls,
		radius = radius,
		WSteps = stacksteps,
		USteps = anglesteps,
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


