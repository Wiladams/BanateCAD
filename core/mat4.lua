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
	mat4_col(m,1),
	mat4_col(m,2),
	mat4_col(m,3),
	mat4_col(m,4)
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

