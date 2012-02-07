
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

function quadratic_U(u, mult)
	mult = mult or 1
	return {mult*3*(u*u), mult*2*u, mult*1, 0}
end

function cubic_U(u, mult)
	mult = mult or 1
	return {mult*u*u*u, mult*u*u, mult*u, mult*1}
end

--function cubic_U(u, mult)
--	mult = mult or 1
--	return {mult*1, mult*u, mult*(u*u), mult*(u*u*u)}
--end

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
	{-1,  3, -3,  1},
	{ 2, -5,  4, -1},
	{-1,  0,  1,  0},
	{ 0,  2,  0,  0}
	}
--[[
-- Transpose
	return {
	{-1,  2, -1,  0},
	{ 3, -5,  4, -2},
	{-3,  4,  1,  0},
	{ 1, -1,  0,  0}
	}
--]]
end


function  cubic_timmer_M()
	return {
	{-2,  4, -4,  2},
	{ 5, -8,  4, -1},
	{-4,  4,  0,  0},
	{ 1,  0,  0,  0}
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


--
-- Catmull ROM Convenience Routines
--
function ccerp(u, cps)
	return cerp(cubic_U(u, 1/2), cubic_catmullrom_M(), cubic_vec3_to_cubic_vec4(cps));
end

local CatmullRom_M = cubic_catmullrom_M()

function catmull_eval(u, mult, geom4)
	return cerp(cubic_U(u, mult), CatmullRom_M, geom4)
end

--=======================================
--
--		Bezier Convenience Routines
--
--=======================================

local Bezier_M = cubic_bezier_M()

function berp(u, cps)
	return cerp(cubic_U(u), cubic_bezier_M(), cubic_vec3_to_cubic_vec4(cps));
end

function bezier_eval(u, geom4)
	return cerp(cubic_U(u, 1), Bezier_M, geom4)
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

