-- maths.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
-- Useful constants
Cphi = 1.61803399;
Cpi = 3.14159
Ctau = Cpi*2
Cepsilon = 0.00000001;

Cdegtorad = 2*Cpi/360;

function radians(degrees)
	return math.pi/180 * degrees;
end

-- Basic vector routines
-- Conversions
function point3h_from_vec3(vec)
	return {vec[1], vec[2], vec[3], 1};
end

function vec3_from_point3h(pt)
	return {pt[1], pt[2], pt[3]};
end

-- Vector addition
function vec2_add(v1, v2)
	return {v1[1]+v2[1], v1[2]+v2[2]}
end

function vec3_add(v1, v2)
	return {v1[1]+v2[1], v1[2]+v2[2], v1[3]+v2[3]}
end

function vec4_add(v1, v2)
	return {v1[1]+v2[1], v1[2]+v2[2], v1[3]+v2[3], v1[4]+v2[4]}
end

-- Vector subtraction
function vec2_sub(v1, v2)
	return {v1[1]-v2[1], v1[2]-v2[2]}
end

function vec3_sub(v1, v2)
	return {v1[1]-v2[1], v1[2]-v2[2], v1[3]-v2[3]}
end

function vec4_sub(v1, v2)
	return {v1[1]-v2[1], v1[2]-v2[2], v1[3]-v2[3], v1[4]-v2[4]}
end

-- Multiply by a scalar
function vec2_mults(v, s)
	return {v[1]*s, v[2]*s}
end

function vec3_mults(v, s)
	return {v[1]*s, v[2]*s, v[3]*s}
end

function vec4_mults(v, s)
	return {v[1]*s, v[2]*s, v[3]*s, v[4]*s}
end

-- Magnitude of a vector
-- Gives the Euclidean norm
function vec3_lengthsquared(v)
	return (v[1]*v[1]+v[2]*v[2]+v[3]*v[3])
end

function vec3_length(v)
	return math.sqrt(vec3_lengthsquared(v))
end

function vec3_norm(v)
	return vec3_mults(v, 1/vec3_length(v))
end

-- Dot Product
function vec3_dot(v1,v2)
	return v1[1]*v2[1]+v1[2]*v2[2]+v1[3]*v2[3]
end

function vec4_dot(v1,v2)
	return v1[1]*v2[1]+v1[2]*v2[2]+v1[3]*v2[3]+v1[4]*v2[4]
end


function vec3_cross(v1, v2)
	return {
		(v1[2]*v2[3])-(v2[2]*v1[3]),
		(v1[3]*v2[1])-(v2[3]*v1[1]),
		(v1[1]*v2[2])-(v2[1]*v1[2])
	}
end


--=========================================
--	Matrix 4X4 Operations
--
-- Upper left 3x3 == scaling, shearing, reflection, rotation (linear transformations)
-- Upper right 3x1 == Perspective transformation
-- Lower left 1x3 == translation
-- Lower right 1x1 == overall scaling
--=========================================

function mat4_identity()
	return {
	{1, 0, 0, 0},
	{0, 1, 0, 0},
	{0, 0, 1, 0},
	{0, 0, 0, 1}
	}
end

function mat4_transpose(m)
	return {
	mat4_col(m,0),
	mat4_col(m,1),
	mat4_col(m,2),
	mat4_col(m,3)
	}
end

function mat4_col(m, col)
	return {
	m[1][col],
	m[2][col],
	m[3][col],
	m[4][col]
	}
end

function mat4_add_mat4(m1, m2)
	return {
	vec4_add(m1[1], m2[1]),
	vec4_add(m1[2], m2[2]),
	vec4_add(m1[3], m2[3]),
	vec4_add(m1[4], m2[4])
	}
end



-- Multiply two 4x4 matrices together
-- This is one of the workhorse mechanisms of the
-- graphics system
function mat4_mult_mat4(m1, m2)
	return {
	{vec4_dot(m1[1], mat4_col(m2,1)),
	vec4_dot(m1[1], mat4_col(m2,2)),
	vec4_dot(m1[1], mat4_col(m2,3)),
	vec4_dot(m1[1], mat4_col(m2,4))},

	{vec4_dot(m1[2], mat4_col(m2,1)),
	vec4_dot(m1[2], mat4_col(m2,2)),
	vec4_dot(m1[2], mat4_col(m2,3)),
	vec4_dot(m1[2], mat4_col(m2,4))},

	{vec4_dot(m1[3], mat4_col(m2,1)),
	vec4_dot(m1[3], mat4_col(m2,2)),
	vec4_dot(m1[3], mat4_col(m2,3)),
	vec4_dot(m1[3], mat4_col(m2,4))},

	{vec4_dot(m1[4], mat4_col(m2,1)),
	vec4_dot(m1[4], mat4_col(m2,2)),
	vec4_dot(m1[4], mat4_col(m2,3)),
	vec4_dot(m1[4], mat4_col(m2,4))},
	}
end

--
-- Function: Iter_matm4_mult_mat4
--
-- Description: Given a matrix of homogenized input
--	points, multiply then by the transform matrix, and
--	return them one by one as an iterator.
function Iter_matm4_mult_mat4(m4, Tm)
	local row=0;

	return function()
		row = row+1;
		if row > #m4 then	-- If we've run out of rows
			return nil;	-- we are done
		else
			return vec4_mult_mat4(m4[row], Tm);
		end
	end
end

-- This is the other workhorse routine
-- Most transformations are a multiplication
-- of a vec4 and a mat4
function vec4_mult_mat4(vec, mat)
	return {
		vec4_dot(vec, mat4_col(mat,1)),
		vec4_dot(vec, mat4_col(mat,2)),
		vec4_dot(vec, mat4_col(mat,3)),
		vec4_dot(vec, mat4_col(mat,4)),
	}
end


function vec4_mult_mat34(vec, mat)
	return {
	vec4_dot(vec, mat4_col(mat,1)),
	vec4_dot(vec, mat4_col(mat,2)),
	vec4_dot(vec, mat4_col(mat,3))
	}
end


-- Linear Transformations
--	Translate
function transform_translate(xyz)
	return {
	{1, 0, 0, 0},
	{0, 1, 0, 0},
	{0, 0, 1, 0},
	{xyz[1], xyz[2], xyz[3], 1}
	}
end

-- 	Scale
function  transform_scale(xyz)
	return {
	{xyz[1],0,0,0},
	{0,xyz[2],0,0},
	{0,0,xyz[3],0},
	{0,0,0,1}
	}
end

--	Rotation
function transform_rotx(deg)
	local rad = Cdegtorad * deg;
	local sinang = math.sin(rad);
	local cosang = math.cos(rad);

	return {
	{1, 0, 0, 0},
	{0, cosang, sinang, 0},
	{0, -sinang, cosang, 0},
	{0, 0, 0, 1}
	}
end

function  transform_rotz(deg)
	local rad = Cdegtorad * deg;
	local sinang = math.sin(rad);
	local cosang = math.cos(rad);

	return {
	{cosang, sinang, 0, 0},
	{-sinang, cosang, 0, 0},
	{0, 0, 1, 0},
	{0, 0, 0, 1}
	}
end

function  transform_roty(deg)
	local rad = Cdegtorad * deg;
	local sinang = math.sin(rad);
	local cosang = math.cos(rad);

	return {
	{cosang, 0, -sinang, 0},
	{0, 1, 0, 0},
	{sinang, 0, cosang, 0},
	{0, 0, 0, 1}
	}
end














--=======================================
--
--	Linear Interpolation Routines
--
--=======================================
function lerpfunc( p0, p1, u)
	return p0 + (p1-p0)*u
end

---[[
function lerp(p0, p1, u)
	if type(p0) == 'number' then
		return  lerpfunc(p0, p1, u)
	end

	local res={}
	for i=1,#p0 do
		table.insert(res, lerpfunc(p0[i], p1[i], u))
	end

	return res
end
--]]


--=======================================
--
--		Cubic Curve Routines
--
--=======================================
function cubic_vec3_to_cubic_vec4(cps)
	return {
		point3h_from_vec3(cps[1]),
		point3h_from_vec3(cps[2]),
		point3h_from_vec3(cps[3]),
		point3h_from_vec3(cps[4])
		}
end

function vec43_to_vec44(mesh)
	return {
		cubic_vec3_to_cubic_vec4(mesh[1]),
		cubic_vec3_to_cubic_vec4(mesh[2]),
		cubic_vec3_to_cubic_vec4(mesh[3]),
		cubic_vec3_to_cubic_vec4(mesh[4]),
		}
end

function quadratic_U(u)
	return {3*(u*u), 2*u, 1, 0}
end

function cubic_U(u)
	return {u*u*u, u*u, u, 1}
end

function cerp(U, M, G)
	return vec4_mult_mat4(vec4_mult_mat4(U, M), G)
end

function cubic_surface_pt(T, A, G, S)
	local pt = vec3_from_point3h(
		vec4_mult_mat4(vec4_mult_mat4(vec4_mult_mat4(T,A), G),S)
	);
	return pt;
end

-- An iterator version
function IterateCubicVertices(M, umult, G, steps)
	local step=-1

	return function()
		step = step+1;
		if step > steps then
			return nil;
		else
			local U = cubic_U(step/steps);
			local pt0 = cerp(U, M, G);

			return pt0;
		end
	end
end

--=====================================================
-- Function: bicerp
-- 		BiCubic Interpolation
--
-- M - Blending Function
-- mesh - 16 control points
-- u - Parametric
-- v - Parametric
--=====================================================
function mesh_col(mesh, col)
	local column = {mesh[1][col], mesh[2][col], mesh[3][col], mesh[4][col]};

	return column;
end

function bicerp(u, w, mesh, M, umult)
	-- 'U' for derivatives
	local dU = vec4_mults(quadratic_U(u), umult);
	local dW = vec4_mults(quadratic_U(w), umult);

	-- 'U' for curve
	local U = vec4_mults(cubic_U(u), umult);
	local W = vec4_mults(cubic_U(w), umult);

	-- Calculate point on curve in 'u' direction
	local uPt1 = cerp(U, M, mesh[1]);
	local uPt2 = cerp(U, M, mesh[2]);
	local uPt3 = cerp(U, M, mesh[3]);
	local uPt4 = cerp(U, M, mesh[4]);

	local wPt1 = cerp(W, M, mesh_col(mesh, 1));
	local wPt2 = cerp(U, M, mesh_col(mesh, 2));
	local wPt3 = cerp(U, M, mesh_col(mesh, 3));
	local wPt4 = cerp(U, M, mesh_col(mesh, 4));


	-- Calculate the surface pt
	local spt = cerp(W, M,{uPt1, uPt2, uPt3, uPt4});

	-- tangent in the 'u' direction
	local tupt = cerp(dU, M, {wPt1, wPt2, wPt3, wPt4});
	-- tangent in the 'w' direction
	local twpt = cerp(dW, M, {uPt1, uPt2, uPt3, uPt4});

	-- Get the normal vector by crossing the two tangent
	-- vectors
	local npt = vec3_norm(vec3_cross(
				vec3_from_point3h(tupt),
				vec3_from_point3h(twpt)));

	--vec3_print(npt);io.write('\n');

	-- return both the point, and the tangent
	return spt, npt;
end

-- Blending Functions
function cubic_hermite_M()
	return {
	{2, -2, 1, 1},
	{-3, 3, -2, -1},
	{0, 0, 1, 0},
	{1, 0, 0, 0}
	}
end

function cubic_bezier_M()
	return {
	{-1, 3, -3, 1},
	{3, -6, 3, 0},
	{-3, 3, 0, 0},
	{1, 0, 0, 0}
	}
end

function cubic_catmullrom_M()
	return {
	{-1, 3, -3, 1},
	{2, -5, 4, -1},
	{-1, 0, 1, 0},
	{0, 2, 0, 0}
	}
end



--	To use the B-spline, you must use a multiplier of 1/6 on the matrix itself
--	Also, the parameter matrix is
--	[(t-ti)^3, (t-ti)^2, (t-ti), 1]

--	and the geometry is

--	[Pi-3, Pi-2, Pi-1, Pi]

--	Reference: http://spec.winprog.org/curves/


function cubic_bspline_M()
	return {
	{-1, 2, -3, 1},
	{3, -6, 3, 0},
	{-3, 0, 3, 0},
	{1, 4, 1, 0},
	}
end



--=======================================
--
--		Bezier Convenience Routines
--
--=======================================

function berp(u, cps)
	return cerp(cubic_U(u), cubic_bezier_M(), cubic_vec3_to_cubic_vec4(cps));
end


-- Calculate a point on a Bezier mesh
-- Given the mesh, and the parametric 'u', and 'v' values
function berpm(u,v, mesh)
	return bcerp(u, v, cubic_bezier_M(), vec43_to_vec44(mesh));
end


--=======================================
--
--		Hermite Convenience Routines
--
--=======================================

function herp(u, cps)
	return ccerp(cubic_U(u), cubic_hermite_M(), cubic_vec3_to_cubic_vec4(cps))
end

-- Calculate a point on a cubic mesh
-- Given the mesh, and the parametric 'u', and 'v' values
function herpm(u, v, mesh)
	return bcerp(u, v, cubic_hermite_M(), vec43_to_vec44(mesh));
end












--[[
==================================
  Spherical coordinates
==================================
--]]

--[[
 create an instance of a spherical coordinate
 long - rotation around z -axis
 lat - latitude, starting at 0 == 'north pole'
 rad - distance from center
--]]
function sph(long, lat, rad)
	return {long, lat, rad}
end

-- Convert spherical to cartesian
function sph_to_cart(s)
	return vec3(
	clean(s[3]*math.sin(s[2])*math.cos(s[1])),
	clean(s[3]*math.sin(s[2])*math.sin(s[1])),
	clean(s[3]*math.cos(s[2]))
	)
end

-- Convert from cartesian to spherical
function sph_from_cart(c)
	return sph(
	math.atan2(c[2],c[1]),
	math.atan2(math.sqrt(c[1]*c[1]+c[2]*c[2]), c[3]),
	math.sqrt(c[1]*c[1]+c[2]*c[2]+c[3]*c[3])
	)
end

function sphu_from_cart(c, rad)
	return sph(
	math.atan2(c[2],c[1]),
	math.atan2(math.sqrt(c[1]*c[1]+c[2]*c[2]), c[3]),
	rad
	)
end

-- compute the chord distance between two points on a sphere
function sph_dist(c1, c2)
	return math.sqrt(
	c1[3]*c1[3] + c2[3]*c2[3] -
	2*c1[3]*c2[3]*
	((math.cos(c1[2])*math.cos(c2[2])) +
	math.cos(c1[1]-c2[1])*math.sin(c1[2])*math.sin(c2[2]))
	);
end



-- Useful functions
function factorial(n)
	if n==0 then
		return 1
	else
		return n * factorial(n-1)
	end
end

--[[
 Function: clean

 Parameters:
	n - A number that might be very close to zero
 Description:
	There are times when you want a very small number to
 	just be zero, instead of being that very small number.
	This function will compare the number to an arbitrarily small
	number.  If it is smaller than the 'epsilon', then zero will be
 	returned.  Otherwise, the original number will be returned.
--]]

function clean(n)
	if (n < 0) then
		if (n < -Cepsilon) then
			return n
		else
			return 0
		end
	else if (n < Cepsilon) then
			return 0
		else
			return n
		end
	end
end

--[[
 Function: safediv

 Parameters
	n - The numerator
	d - The denominator

 Description:
	Since division by zero is generally not a desirable thing, safediv
	will return '0' whenever there is a division by zero.  Although this will
	mask some erroneous division by zero errors, it is often the case
	that you actually want this behavior.  So, it makes it convenient.
--]]
function safediv(n,d)
	if (d==0) then
		return 0
	end

	return n/d;
end


-- Calculate the centroid of a list of vertices

function centroid(verts)
	local minx = math.huge; maxx = -math.huge
	local miny = math.huge; maxy = -math.huge
	local minz = math.huge; maxz = -math.huge

	for _,v in ipairs(verts) do
		minx = math.min(v[1], minx); maxx = math.max(v[1], maxx);
		miny = math.min(v[2], miny); maxy = math.max(v[2], maxy);
		minz = math.min(v[3], minz); maxz = math.max(v[3], maxz);
	end

	local x = minx + (maxx-minx)/2;
	local y = miny + (maxy-miny)/2;
	local z = minz + (maxz-minz)/2;

	return vec3(x,y,z)
end

function normalizeAngle(angle)
	while angle < 0 do
		angle = angle + 360;
	end

	while angle > 360 do
		angle = angle - 360;
	end

	return angle;
end
