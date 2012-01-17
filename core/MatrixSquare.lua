local class = require "pl.class"
require "Matrix"

class.MatrixSquare(Matrix)

function MatrixSquare:_init(n)
	-- n could be either a single number,
	-- in which case it is the dimension of the square
	if type(n) == "number" then
		self:super(n,n);
		self:MakeIdentity();
	else
		-- or it could be a 2D array
		self:super(n);
	end

	self.Determinant = 0;
end


function MatrixSquare.ComponentMultiply(self, y)
	local r = Matrix(self.ColumnDimension, y.RowDimension);

	for row = 1, self.RowDimension do
		for column = 1, y.ColumnDimension do
			r[row][column] = self[row][column] * y[row][column];
		end
	end

	return r;
end

function MatrixSquare.Trace(self)
	local diag = self:GetDiagonal()


	if not diag then return nil end

	-- summarize elements of the diagonal
	local sum = 0
	for _,e in ipairs(diag) do
		sum = sum + e
	end

	return sum
end

function MatrixSquare.GetDiagonal(self)
	local diag = {}
	for i=1,#self do
		diag[i] = self[i][i]
	end

	return diag
end


function MatrixSquare.SetDiagonal(self, value)
	for i = 1, self.ColumnDimension do
		self[i][i] = value;
	end
end

function MatrixSquare.MakeIdentity(self)
	self:Clear();
	self:SetDiagonal(1);
end

function MatrixSquare.GetDeterminant(self)
	obj = LUdcmp(self);
	d = obj.det();

	return d;
end


-- public double[,] GetInverse()
function MatrixSquare.GetInverse(self)
--	LUdcmp obj = new LUdcmp(el);
--	double[,] x = obj.inverse();

--	local mat = MatrixSquare(x)
--	return mat;
	return nil;
end

function MatrixSquare.__add(self, m2)
	local mat = MatrixSquare(self.RowDimension)

	for row =1, self.RowDimension do
		for column =1, self.ColumnDimension do
			mat[row][column] = self[row][column] + m2[row][column]
		end
	end

	return mat;
end

function MatrixSquare.__sub(self, m2)
	local mat = MatrixSquare(self.RowDimension)

	for row =1, self.RowDimension do
		for column =1, self.ColumnDimension do
			mat[row][column] = self[row][column] - m2[row][column]
		end
	end

	return mat;
end

function MatrixSquare.__unm(self)
	local mat = MatrixSquare(self.RowDimension)

	for row =1, self.RowDimension do
		for column =1, self.ColumnDimension do
			num = self[row][column]
			if num ~= 0 then
				mat[row][column] = -num
			end
		end
	end

	return mat;
end

function Matrix4()
	local mat = MatrixSquare(4)

	return mat
end

--[[
print("MatrixSquare.lua - TEST")
local m1 = MatrixSquare(3)
m1:Print()
print("Trace: ", m1:Trace())

local m3 = m1 + m1
print("Added")
m3:Print()

print("Subtracted")
local m4 = m1 - m1
m4:Print()

print("Multiplied")
local m5 = m3:ComponentMultiply(m3)
m5:Print();

print("Negated")
local m6 = -m3
m6:Print()

print("Matrix4 Multiply")
local mm1 = Matrix4()
local mm2 = Matrix4()
local mm3 = mm1 * mm2

mm3:Print()

--]]
