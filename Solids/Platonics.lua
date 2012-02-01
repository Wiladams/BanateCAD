-- Platonics.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
require "maths"
local class = require "pl.class"

--[[

// Information about platonic solids
// This information is useful in constructing the various solids
// can be found here: http://en.wikipedia.org/wiki/Platonic_solid
// V - vertices
// E - edges
// F - faces
// number, V, E, F, schlafli symbol, dihedral angle, element, name
//tetrahedron = [1, 4, 6, 4, [3,3], 70.5333, "fire", "tetrahedron"];
//hexahedron = [2, 8, 12, 6, [4,3], 90, "earth", "cube"];
//octahedron = [3, 6, 12, 8, [3,4], 109.467, "air", "air"];
//dodecahedron = [4, 20, 30, 12, [5,3], 116.565, "ether", "universe"];
//icosahedron = [5, 12, 30, 20, [3,5], 138.190, "water", "water"];
--]]


-- Schlafli representation for the platonic solids
-- Given this representation, we have enough information
-- to derive a number of other attributes of the solids
class.schlafli()
function schlafli:_init(params)
	params = params or {}		-- create object if user does not provide one

	self.p = params.p
	self.q = params.q
end

tetra_sch = schlafli({p=3,q=3});
hexa_sch = schlafli({p=4,q=3});
octa_sch = schlafli({p=3,q=4});
dodeca_sch = schlafli({p=5,q=3});
icosa_sch = schlafli({p=3,q=5});

--[[
-- Given the schlafli representation, calculate
-- the number of edges, vertices, and faces for the solid
function plat_edges(pq)
	return (2*pq[1]*pq[2])/
	((2*pq[1])-(pq[1]*pq[2])+(2*pq[2]));
end

function plat_vertices(pq)
	return (2*plat_edges(pq))/pq[2];
end

function plat_faces(pq)
	return (2*plat_edges(pq))/pq[1];
end



-- Calculate angular deficiency of each vertex in a platonic solid
-- p - sides
-- q - number of edges per vertex
--function angular_defect(pq) = math.pi*2 - (poly_single_interior_angle(pq)*pq[2]);
function plat_deficiency(pq)
	return math.deg(2*Cpi - pq[2]*Cpi*(1-2/pq[1]));
end

function plat_dihedral(pq)
	return 2 * math.asin( math.cos(math.pi/pq[2])/math.sin(math.pi/pq[1]));
end

function plat_circumradius(pq, a)
	return (a/2)*
	math.tan(Cpi/pq[2])*
	math.tan(plat_dihedral(pq)/2);
end

function plat_midradius(pq, a)
	return (a/2)*
	math.cot(Cpi/pq[1])*
	math.tan(plat_dihedral(pq)/2);
end

function plat_inradius(pq,a)
	return a/(2*math.tan(Cpi/pq[1]))*
	math.sqrt((1-math.cos(plat_dihedral(pq)))/(1+math.cos(plat_dihedral(pq))));
end
--]]

--[[
shape_platonic = {}
function shape_platonic:_init(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end

function shape_tetrahedron.GetMesh(self)
	local mesh = trimesh({name="tetrahedron"})

	for i,v in ipairs(tetra_cart) do
		mesh:addvertex(v);
	end

	for j,face in ipairs(tetra_faces) do
		mesh:addface(face)
	end

	return mesh;
end
--]]

--================================================
--	Tetrahedron
--================================================
tetra_cart = {
	{1, 1, 1},
	{-1, -1, 1},
	{-1, 1, -1},
	{1, -1, -1}
};


function tetra_unit(rad)
	return {
	sph_to_cart(sphu_from_cart(tetra_cart[1], rad)),
	sph_to_cart(sphu_from_cart(tetra_cart[2], rad)),
	sph_to_cart(sphu_from_cart(tetra_cart[3], rad)),
	sph_to_cart(sphu_from_cart(tetra_cart[4], rad)),
	};
end


tetra_faces = {
	{1, 4, 2},
	{1,2,3},
	{3,2,4},
	{1,3,4}
};

tetra_edges = {
	{1,2},
	{1,3},
	{1,4},
	{2,3},
	{2,4},
	{3,4},
	};

--function tetrahedron(rad=1) = [tetra_unit(rad), tetrafaces, tetra_edges];
class.shape_tetrahedron()
function shape_tetrahedron:_init(o)
	o = o or {}		-- create object if user does not provide one

	self.radius = o.radius or 1
end

function shape_tetrahedron.GetMesh(self)
	local mesh = trimesh({name="tetrahedron"})

	if self.radius ~= nil then
		verts = tetra_unit(self.radius)
	else
		verts = tetra_cart
	end

	for i,v in ipairs(verts) do
		mesh:addvertex(v);
	end

	for j,face in ipairs(tetra_faces) do
		mesh:addface(face)
	end

	return mesh;
end


--[[
//================================================
//	Hexahedron - Cube
//================================================
--]]
-- vertices for a unit cube with sides of length 1
hexa_cart = {
	{0.5, 0.5, 0.5},
	{-0.5, 0.5, 0.5},
	{-0.5, -0.5, 0.5},
	{0.5, -0.5, 0.5},
	{0.5, 0.5, -0.5},
	{-0.5, 0.5, -0.5},
	{-0.5, -0.5, -0.5},
	{0.5, -0.5, -0.5},
};


function hexa_unit(rad)
	return {
	sph_to_cart(sphu_from_cart(hexa_cart[1], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[2], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[3], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[4], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[5], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[6], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[7], rad)),
	sph_to_cart(sphu_from_cart(hexa_cart[8], rad)),
	};
end


-- enumerate the faces of a cube
-- vertex order is clockwise winding
hexa_faces = {
	{1,4,3},	-- top
	{1,3,2},
	{1,2,6},
	{1,6,5},
	{2,3,7},
	{2,7,6},
	{3,4,8},
	{3,8,7},
	{4,1,5},
	{4,5,8},
	{5,6,7},	-- bottom
	{5,7,8},
};

--[[
hexa_edges = [
	[0,1],
	[0,3],
	[0,4],
	[1,2],
	[1,5],
	[2,3],
	[2,6],
	[3,7],
	[4,5],
	[4,7],
	[5,4],
	[5,6],
	[6,7],
	];
--]]

--function hexahedron(rad=1) =[hexa_unit(rad), hexafaces, hexa_edges];

class.shape_hexahedron()
function shape_hexahedron:_init(o)
	o = o or {}		-- create object if user does not provide one

	self.radius = o.radius or 1
end

function shape_hexahedron.GetMesh(self)
	local mesh = trimesh({name="hexahedron"})

	if self.radius ~= nil then
		verts = hexa_unit(self.radius)
	else
		verts = hexa_cart
	end

	for i,v in ipairs(verts) do
		mesh:addvertex(v);
	end

	for j,face in ipairs(hexa_faces) do
		mesh:addface(face)
	end

	return mesh;
end

--[[
//================================================
//	Octahedron
//================================================
--]]

octa_cart = {
	{1, 0, 0},  -- + x axis
	{-1, 0, 0},	-- - x axis
	{0, 1, 0},	-- + y axis
	{0, -1, 0},	-- - y axis
	{0, 0, 1},	-- + z axis
	{0, 0, -1} 	-- - z axis
};

function octa_unit(rad)
	return {
	sph_to_cart(sphu_from_cart(octa_cart[1], rad)),
	sph_to_cart(sphu_from_cart(octa_cart[2], rad)),
	sph_to_cart(sphu_from_cart(octa_cart[3], rad)),
	sph_to_cart(sphu_from_cart(octa_cart[4], rad)),
	sph_to_cart(sphu_from_cart(octa_cart[5], rad)),
	sph_to_cart(sphu_from_cart(octa_cart[6], rad)),
	};
end

octa_faces = {
	{5,3,1},
	{5,1,4},
	{5,4,2},
	{5,2,3},
	{6,1,3},
	{6,4,1},
	{6,2,4},
	{6,3,2}
	};
--[[
octa_edges = [
	[0,2],
	[0,3],
	[0,4],
	[0,5],
	[1,2],
	[1,3],
	[1,4],
	[1,5],
	[2,4],
	[2,5],
	[3,4],
	[3,5],
	];

function octahedron(rad=1) = [octa_unit(rad), octafaces, octa_edges];
--]]
class.shape_octahedron()
function shape_octahedron:_init(o)
	o = o or {}		-- create object if user does not provide one

	self.radius = o.radius or 1
end

function shape_octahedron.GetMesh(self)
	local verts = octa_cart
	if self.radius ~= nil then
		verts = octa_unit(self.radius)
	end

	local mesh = trimesh({name="octahedron"})

	for i,v in ipairs(verts) do
		mesh:addvertex(v);
	end

	for j,face in ipairs(octa_faces) do
		mesh:addface(face)
	end

	return mesh;
end

--[[
//================================================
//	Dodecahedron
//================================================
// (+-1, +-1, +-1)
// (0, +-1/Cphi, +-Cphi)
// (+-1/Cphi, +-Cphi, 0)
// (+-Cphi, 0, +-1/Cphi)
--]]
dodeca_cart = {
	{1, 1, 1},			-- 0, 0
	{1, -1, 1},			-- 0, 1
	{-1, -1, 1},			-- 0, 2
	{-1, 1, 1},			-- 0, 3

	{1, 1, -1},			-- 1, 4
	{-1, 1, -1},			-- 1, 5
	{-1, -1, -1},			-- 1, 6
	{1, -1, -1},			-- 1, 7

	{0, 1/Cphi, Cphi},		-- 2, 8
	{0, -1/Cphi, Cphi},		-- 2, 9
	{0, -1/Cphi, -Cphi},		-- 2, 10
	{0, 1/Cphi, -Cphi},		-- 2, 11

	{-1/Cphi, Cphi, 0},		-- 3, 12
	{1/Cphi, Cphi, 0},		-- 3, 13
	{1/Cphi, -Cphi, 0},		-- 3, 14
	{-1/Cphi, -Cphi, 0},		-- 3, 15

	{-Cphi, 0, 1/Cphi},		-- 4, 16
	{Cphi, 0, 1/Cphi},		-- 4, 17
	{Cphi, 0, -1/Cphi},		-- 4, 18
	{-Cphi, 0, -1/Cphi},		-- 4, 19
};


function dodeca_unit(rad)
	return {
	sph_to_cart(sphu_from_cart(dodeca_cart[1], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[2], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[3], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[4], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[5], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[6], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[7], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[8], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[9], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[10], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[11], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[12], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[13], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[14], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[15], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[16], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[17], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[18], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[19], rad)),
	sph_to_cart(sphu_from_cart(dodeca_cart[20], rad)),
	};
end


-- These are the pentagon faces
-- but CGAL has a problem rendering if things are
-- not EXACTLY coplanar
-- so use the triangle faces instead
--[[
dodeca_faces={
	{2,10,9,1,18},
	{10,2,15,16,3},
	{10,3,17,4,9},
	{9,4,13,14,1},
	{1,14,5,19,18},
	{2,18,19,8,15},
	{16,15,8,11,7},
	{3,16,7,20,17},
	{17,20,6,13,4},
	{13,6,12,5,14},
	{19,5,12,11,8},
	{20,7,11,12,6}
	};
--]]


dodeca_faces = {
	{2,10,9},
	{2,9,1},
	{2,1,18},

	{10,2,15},
	{10,15,16},
	{10,16,3},

	{10,3,17},
	{10,17,4},
	{10,4,9},

	{9,4,13},
	{9,13,14},
	{9,14,1},

	{1,14,5},
	{1,5,19},
	{1,19,18},

	{2,18,19},
	{2,19,8},
	{2,8,15},

	{16,15,8},
	{16,8,11},
	{16,11,7},

	{3,16,7},
	{3,7,20},
	{3,20,17},

	{17,20,6},
	{17,6,13},
	{17,13,4},

	{13,6,12},
	{13,12,5},
	{13,5,14},

	{19,5,12},
	{19,12,11},
	{19,11,8},

	{20,7,11},
	{20,11,12},
	{20,12,6}
	};


--[[
dodeca_edges=[
	[0,8],
	[0,13],
	[0,17],

	[1,9],
	[1,14],
	[1,17],

	[2,9],
	[2,15],
	[2,16],

	[3,8],
	[3,12],
	[3,16],

	[4,11],
	[4,13],
	[4,18],

	[5,11],
	[5,12],
	[5,19],

	[6,10],
	[6,15],
	[6,19],

	[7,10],
	[7,14],
	[7,18],

	[8,9],
	[10,11],
	[12,13],
	[14,15],
	[16,19],
	[17,18],
	];

function dodecahedron(rad=1) = [dodeca_unit(rad), dodeca_faces, dodeca_edges];
--]]

class.shape_dodecahedron()
function shape_dodecahedron:_init(o)
	o = o or {}		-- create object if user does not provide one

	self.radius = o.radius or 1
end

function shape_dodecahedron.GetMesh(self)
	local	verts = dodeca_cart
	local faces = dodeca_faces

	if self.radius ~= nil then
		verts = dodeca_unit(self.radius)
	end

	local mesh = trimesh({name="dodecahedron"})

	for i,v in ipairs(verts) do
		mesh:addvertex(v);
	end

	for j,face in ipairs(faces) do
		mesh:addface(face)
	end

	return mesh;
end

--[[
//================================================
//	Icosahedron
//================================================
//
// (0, +-1, +-Cphi)
// (+-Cphi, 0, +-1)
// (+-1, +-Cphi, 0)
--]]

icosa_cart = {
	{0, 1, Cphi},	-- 0
	{0, 1, -Cphi},	-- 1
	{0, -1, -Cphi},	-- 2
	{0, -1, Cphi},	-- 3

	{Cphi, 0, 1},	-- 4
	{Cphi, 0, -1},	-- 5
	{-Cphi, 0, -1},	-- 6
	{-Cphi, 0, 1},	-- 7

	{1, Cphi, 0},	-- 8
	{1, -Cphi, 0},	-- 9
	{-1, -Cphi, 0},	-- 10
	{-1, Cphi, 0}	-- 11
	};

--[[
function icosa_sph(rad=1) = [
	sphu_from_cart(icosa_cart[0], rad),
	sphu_from_cart(icosa_cart[1], rad),
	sphu_from_cart(icosa_cart[2], rad),
	sphu_from_cart(icosa_cart[3], rad),
	sphu_from_cart(icosa_cart[4], rad),
	sphu_from_cart(icosa_cart[5], rad),
	sphu_from_cart(icosa_cart[6], rad),
	sphu_from_cart(icosa_cart[7], rad),
	sphu_from_cart(icosa_cart[8], rad),
	sphu_from_cart(icosa_cart[9], rad),
	sphu_from_cart(icosa_cart[10], rad),
	sphu_from_cart(icosa_cart[11], rad),
	];
--]]

function icosa_unit(rad)
	return {
	sph_to_cart(sphu_from_cart(icosa_cart[1], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[2], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[3], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[4], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[5], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[6], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[7], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[8], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[9], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[10], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[11], rad)),
	sph_to_cart(sphu_from_cart(icosa_cart[12], rad)),
	};
end

icosa_faces = {
	{4,1,5},
	{4,5,10},
	{4,10,11},
	{4,11,8},
	{4,8,1},
	{1,9,5},
	{1,8,12},
	{1,12,9},
	{5,9,6},
	{5,6,10},
	{8,11,7},
	{8,7,12},
	{10,6,3},
	{10,3,11},
	{3,7,11},
	{2,6,9},
	{2,9,12},
	{2,12,7},
	{6,2,3},
	{3,2,7}
	};

--[[
icosa_edges = [
	[0,3],
	[0,4],
	[0,7],
	[0,8],
	[0,11],
	[1,5],
	[1,8],
	[1,11],
	[1,6],
	[1,2],
	[2,5],
	[2,6],
	[2,9],
	[2,10],
	[3,4],
	[3,9],
	[3,10],
	[3,7],
	[4,5],
	[4,8],
	[4,9],
	[5,8],
	[5,9],
	[6,7],
	[6,10],
	[6,11],
	[7,10],
	[7,11],
	[8,11],
	[9,10],
	];

function icosahedron(rad=1) = [icosa_unit(rad), icosa_faces, icosa_edges];
--]]
class.shape_icosahedron()
function shape_icosahedron:_init(o)
	o = o or {}		-- create object if user does not provide one

	self.radius = o.radius or 1
end

function shape_icosahedron.GetMesh(self)
	if self.radius ~= nil then
		verts = icosa_unit(self.radius)
	else
		verts = icosa_cart
	end

	local mesh = trimesh({name="icosahedron"})

	for i,v in ipairs(verts) do
		mesh:addvertex(v);
	end

	for j,face in ipairs(icosa_faces) do
		mesh:addface(face)
	end

	return mesh;
end

