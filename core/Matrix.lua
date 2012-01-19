class = require "pl.class"
require "LinearAlgebra"

class.Matrix()

function Matrix:_init(...)
	local initialValue;

	if arg.n == 1 then
		-- If it's one argument, then assume it
		-- is an array, either 1D, or 2D
		local other = arg[1]
		local rows = #other
		local columns = rows

		if type(other[1]) == "table" then
			columns = #other[1]
		else
			rows = 1
		end

		self.RowDimension = rows
		self.ColumnDimension = columns

		self:CopyArray(other)

	elseif arg.n == 2 then
		-- could be two arguments
		-- rows, columns
		self.RowDimension = arg[1]
		self.ColumnDimension = arg[2]

		for row=1, self.RowDimension do
			local newrow = {}
			for column=1, self.ColumnDimension do
				newrow[column] = 0
			end
			self[row] = newrow
		end
	elseif arg.n == 3 then
		-- With three arguments
		-- rows, columns, data
		self.RowDimension = arg[1]
		self.ColumnDimension = arg[2]
		local data = arg[3]

		self:CopyArray(data)
	end
end

function Matrix.CopyArray(self, other)
	local rows = self.RowDimension
	local columns = self.ColumnDimension

	if rows == 1 or columns == 1 then
		local entries = #other
		for entry =1, entries do
			self[entry] = other[entry]
		end
	elseif rows > 1 and columns > 1 then
		for row=1, rows do
			local newrow = {}
			for column=1, columns do
				newrow[column] = other[row][column]
			end
			self[row] = newrow
		end
	end
end

function Matrix.Clear(self)
	for row = 1, self.RowDimension do
		for column = 1, self.ColumnDimension do
			self:SetElement(row, column, 0)
		end
	end
end

function Matrix.SetElement(self, row, column, num)
	if self.RowDimension > 1 and self.ColumnDimension > 1 then
		self[row][column] = num
	elseif self.RowDimension == 1 then
		self[column] = num
	elseif self.ColumnDimension == 1 then
		self[row] = num
	end
end

function Matrix.GetElement(self, row, column)
	if self.RowDimension > 1 and self.ColumnDimension > 1 then
		return self[row][column]
	elseif self.RowDimension == 1 then
		return self[column]
	elseif self.ColumnDimension == 1 then
		return self[row]
	end

	return nil
end

function Matrix.GetColumn(self, columnNumber)
	if (columnNumber > self.ColumnDimension) then
		return nil;
	end

	local columnVector = Matrix(self.RowDimension,1);

	for r = 1, self.RowDimension do
		columnVector:SetElement(r,1, self:GetElement(r, columnNumber));
	end

	return columnVector;
end

function Matrix.SetColumn(columnNumber, columnVector)
	-- column number out of range
	-- just return
	if (columnNumber > self.ColumnDimension) then
		return ;
	end

	if (#columnVector ~= self.RowDimension) then
		return;
	end

	for r = 1, self.RowDimension do
		self:SetElement(r, columnNumber, columnVector[r]);
	end
end

function Matrix.Transpose(self)
	local ma = Matrix(self.ColumnDimension, self.RowDimension);

	for k = 1, self.ColumnDimension do
		for kk = 1, self.RowDimension do
			ma:SetElement(k,kk, self[kk][k]);
		end
	end

	return ma;
end

--[=====[
	Operator Overloads
--]=====]
function Matrix.__mul(a, c)
	b = Matrix(a.RowDimension, c.ColumnDimension);

	for k = 1, b.RowDimension do
		for j = 1, b.ColumnDimension do
			local sum = 0.0;
			for s = 1, a.ColumnDimension do
				sum = sum + (a:GetElement(k,s) * c:GetElement(s,j));
			end
			b:SetElement(k,j, sum);
		end
	end

	return b;
end

--[[
	Utility Routines
--]]
function Matrix.Print(self)
	print("Matrix")
	print("Rows: ", self.RowDimension)
	print("Columns: ", self.ColumnDimension)


	for row=1, self.RowDimension do
		for col = 1, self.ColumnDimension do
			io.write(self:GetElement(row,col))
			--io.write(self[row][col])
			io.write(", ")
		end
		io.write("\n")
	end
end

--[[
print("Matrix.lua - TEST")
local ms = Matrix(2,2)
ms:Print()

local ma = Matrix(4, 2)
ma:SetElement(1,1, 0)
ma:SetElement(1,2, 0)

ma:SetElement(2,1, 1)
ma:SetElement(2,2, 0)

ma:SetElement(3,1, 1)
ma:SetElement(3,2, 1)

ma:SetElement(4,1, 0)
ma:SetElement(4,2, 1)

ma:Print()

local matrans = ma:Transpose()

print("Transpose")
matrans:Print()

print("Copy Constructor")
local clearing = Matrix(matrans)
clearing:Print()

print("Clear")
clearing:Clear()
clearing:Print()

print("Matrix 1D")
local m1 = Matrix({10, 20, 30})
m1:Print()
local m2 = Matrix(3,1)
m2:CopyArray({20, 30, 40})
m2:Print()

print("Matrix 2D")
local m2D = Matrix({{1, 0}, {0,1}})
m2D:Print()

print("Columnar")
local mcolumnar = Matrix(3,1, {4,5,6})
mcolumnar:Print()
local mrow = Matrix(1,3, {4,5,6})
mrow:Print()

--]]



