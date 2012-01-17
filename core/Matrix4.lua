local class = require "pl.class"
require "MatrixSquare"

--=========================================
--	Matrix 4X4 Operations
--
-- Upper left 3x3 == scaling, shearing, reflection, rotation (linear transformations)
-- Upper right 3x1 == Perspective transformation
-- Lower left 1x3 == translation
-- Lower right 1x1 == overall scaling
--=========================================
class.Matrix4(MatrixSquare)

function Matrix4:_init(params)
	self:super(4)
--[[
	params = params or {
		{1, 0, 0, 0},
		{0, 1, 0, 0},
		{0, 0, 1, 0},
		{0, 0, 0, 1}
		}
--]]
end

function Matrix4.col(self, col)
	local column = {
		self[1][col],
		self[2][col],
		self[3][col],
		self[4][col]
		}

	return vec.new(column)
end


--[[
-- Multiply two 4x4 matrices together
-- This is one of the workhorse mechanisms of the
-- graphics system
function Matrix4.__mul(m1, m2)
	local mat = Matrix4({
	{m1[1]:dot(m2:col(1)),
	m1[1]:dot(m2:col(2)),
	m1[1]:dot(m2:col(3)),
	m1[1]:dot(m2:col(4))},

	{m1[2]:dot(m2:col(1)),
	m1[2]:dot(m2:col(2)),
	m1[2]:dot(m2:col(3)),
	m1[2]:dot(m2:col(4))},

	{m1[3]:dot(m2:col(1)),
	m1[3]:dot(m2:col(2)),
	m1[3]:dot(m2:col(3)),
	m1[3]:dot(m2:col(4))},

	{m1[4]:dot(m2:col(1)),
	m1[4]:dot(m2:col(2)),
	m1[4]:dot(m2:col(3)),
	m1[4]:dot(m2:col(4))},
	})

	return mat
end
--]]

--
-- Function: Iter_matm4_mult_Matrix4
--
-- Description: Given a matrix of homogenized input
--	points, multiply then by the transform matrix, and
--	return them one by one as an iterator.
function Iter_matm4_mult_Matrix4(m4, Tm)
	local row=0;

	return function()
		row = row+1;
		if row > #m4 then	-- If we've run out of rows
			return nil;	-- we are done
		else
			return vec4_mult_Matrix4(m4[row], Tm);
		end
	end
end


function vec4_mult_mat34(vec, mat)
	return {
	vec4_dot(vec, Matrix4_col(mat,1)),
	vec4_dot(vec, Matrix4_col(mat,2)),
	vec4_dot(vec, Matrix4_col(mat,3))
	}
end


Matrix4.Identity = Matrix4()



---[==[
print("Matrix4.lua - TEST");

local mat1 = Matrix4()
local mat2 = Matrix4()

print("Identity")
mat1:Print()

--[[
print("Added")
local matadded = mat1 + mat2
local multed = mat1 * mat2

matadded:Print()
multed:Print()


print("Matrix Multiply")
--local mm1 = Matrix4()
--local mm2 = Matrix4()
--local mm3 = mm1 * mm2

--mm3:Print()
--]]
--]==]


return Matrix4
