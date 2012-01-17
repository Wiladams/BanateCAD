local class = require "pl.class"

require "MatrixSquare"

-- Linear Transformations
class.Transformer()


function Transformer:_init()
	self.CurrentMatrix = Matrix4()
	self.TransformStack = {}
end

function Transformer.Reset(self)
	self.CurrentMatrix = Matrix4()
	self.TransformStack = {}
end

function Transformer.PushMatrix(self)
	table.insert(self.TransformStack, self.CurrentMatrix);
end

function Transformer.PopMatrix(self)
	if #self.TransformStack < 1 then
		return
	end

	self.CurrentMatrix = table.remove(self.TransformStack)

	return self.CurrentMatrix
end

function Transformer.Get2DMatrix(self)
	local res = {}
	res[1] = self.CurrentMatrix[1][1]	-- sx
	res[2] = 0 -- self.CurrentMatrix[2][1]	-- rot

	res[3] = 0 -- self.CurrentMatrix[1][2]	-- rot
	res[4] = self.CurrentMatrix[2][2]	-- sy

	res[5] = self.CurrentMatrix[4][1]	-- dx
	res[6] = self.CurrentMatrix[4][2]	-- dy

	return res;
end

function Transformer.AppendMatrix(self, mat)
	self.CurrentMatrix = self.CurrentMatrix * mat;
	return self.CurrentMatrix;
end

-- This is the other workhorse routine
-- Most transformations are a multiplication
-- of a vec4 and a Matrix4
--[[
	local res = vec.new {
		avec:dot(self:col(1)),
		avec:dot(self:col(2)),
		avec:dot(self:col(3)),
		avec:dot(self:col(4)),
	}
--]]
function Transformer.Transform(self, ...)
	local pt = Matrix(1,4)

	-- the parameters could be
	-- 1) a single entry which is a table

	if arg.n == 1 and type(arg[1]) == "table" then
		-- minimum number of entries
		local n = math.min(#arg[1], 4)

		for i = 1, n do
			pt:SetElement(1,i, arg[1][i])
		end
		if n < 4 then
			pt:SetElement(1,4,1)
		end
	end

--print("Transformer.Transform")
--print(pt[1], pt[2], pt[3], pt[4])
--pt:Print()

	local res = pt * self.CurrentMatrix

	return res
end

	--	Translate
function Transformer.Translate(self, dx, dy, dz)
	dz = dz or 0
--print("Transformer.Translate: ", dx, dy, dz)

	self.CurrentMatrix[4][1] = self.CurrentMatrix[4][1] + dx;
	self.CurrentMatrix[4][2] = self.CurrentMatrix[4][2] + dy;
	self.CurrentMatrix[4][3] = self.CurrentMatrix[4][3] + dz;

	return self.CurrentMatrix;
end

-- 	Scale
function  Transformer.Scale(self, sx, sy, sz)
	sz = sz or 1

	local mat = Matrix4()
	mat[1][1] = sx;
	mat[2][2] = sy;
	mat[3][3] = sz;

	return self:AppendMatrix(mat);
end

--	Rotation
function Transformer.Rotate(self, rx,ry,rz)
	rz = rz or 0

	self:RotateX(rx)
	self:RotateY(ry)
	self:RotateZ(rz)

	return self.CurrentMatrix
end

function Transformer.RotateX(self, rad)
	local sinang = math.sin(rad);
	local cosang = math.cos(rad);

	local mat = Matrix4{
	{1, 0, 0, 0},
	{0, cosang, sinang, 0},
	{0, -sinang, cosang, 0},
	{0, 0, 0, 1}
	}

	return self:AppendMatrix(mat)
end

function  Transformer.RotateZ(self, rad)
	local sinang = math.sin(rad);
	local cosang = math.cos(rad);

	local mat = Matrix4{
	{cosang, sinang, 0, 0},
	{-sinang, cosang, 0, 0},
	{0, 0, 1, 0},
	{0, 0, 0, 1}
	}

	return self:AppendMatrix(mat)
end

function  Transformer.RotateY(self, rad)
	local sinang = math.sin(rad);
	local cosang = math.cos(rad);

	local mat = Matrix4{
	{cosang, 0, -sinang, 0},
	{0, 1, 0, 0},
	{sinang, 0, cosang, 0},
	{0, 0, 0, 1}
	}

	return self:AppendMatrix(mat)
end

--[==[
--[[
	Transforms
--]]
function Matrix4.Translation(dx, dy, dz)
	local mat = Matrix4()
	mat[4][1] = dx
	mat[4][2] = dy
	mat[4][3] = dz

	return mat
end

function Matrix4.Scale(sx, sy, sz)
	local mat = Matrix4()
	mat[1][1] = sx
	mat[2][2] = sy
	mat[3][3] = sz

	return mat
end

function Matrix4.RotateX(rads)
	local mat = Matrix4()

	mat[2][2] = math.cos(rads)
	mat[2][3] = math.sin(rads)

	mat[3][2] = -math.sin(rads)
	mat[3][3] = math.cos(rads)

	return mat
end

function Matrix4.RotateY(rads)
	local mat = Matrix4()

	mat[1][1] = math.cos(rads)
	mat[1][3] = -math.sin(rads)

	mat[3][1] = math.sin(rads)
	mat[3][3] = math.cos(rads)

	return mat
end

function Matrix4.RotateZ(rads)
	local mat = Matrix()

	mat[1][1] = math.cos(rads)
	mat[1][2] = math.sin(rads)

	mat[2][1] = -math.sin(rads)
	mat[2][2] = math.cos(rads)

	return mat
end
--]==]


--[[
print("Transformer.lua - TEST")

local t1 = Transformer()
t1.CurrentMatrix:Print()

-- Create a translation matrix
t1:Scale(5, 5, 1)
t1:Translate(10,10,0)
t1.CurrentMatrix:Print()

local v2 = t1:Get2DMatrix()
print("2D Matrix")
for i=1,#v2 do
	print(v2[i])
end


local pt2 = t1:Transform({1,1,1})
pt2:Print()

print("PushMatrix")
local t2 = Transformer()
t2:PushMatrix()
t2:Scale(10, 15, 20)
t2.CurrentMatrix:Print()
t2:PopMatrix()
t2.CurrentMatrix:Print()
--]]
