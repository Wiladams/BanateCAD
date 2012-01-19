--[[
LUDCMP is based on the routine of the same name
in Numerical Recipes in C: The Art of Scientific Computing,
by Flannery, Press, Teukolsky, and Vetterling, Cambridge
University Press, Cambridge, MA, 1988.

It is used by permission.
--]]
local class = require "pl.class"
require "Matrix"


function createArray(rows, columns, initialValue)
	initialValue = initialValue or 0
	local array = {}

	for row=1, rows do
		local newrow = {}
		for column=1, columns do
			newrow[column] = initialValue
		end
		array[row] = newrow
	end

	return array
end

class.LUdcmp()




public int[] RowPermutation -- output
	return self.indx;
end

public double Sign -- output
	return self.d
end

local TINY = 1.0e-40;

function LUdcmp:_init(double[,] a)   -- a input
	int n;
	private double[,] lu;
	private int[] indx;
	private double d;
	private double[,] aref;

	self.n = #a[1];
	self.LU = new double[n, n];

	for ir = 1, n do
		for ic = 1, n do
			self.LU[ir][ic] = a[ir][ic];
		end
	end

	self.aref = a;
	self.indx = {}

	local imax = 0,
	local i, j, k;
	local big, temp;
    local vv = {}
    self.d = 1.0;

	for i = 1; n do
		big = 0.0;
		for j = 1, n do
                    if ((temp = Math.Abs(lu[i, j])) > big)
                        big = temp;
		end

		if big == 0.0 then
			throw new Exception("Singular matrix in LUdcmp");  -- "Singular matrix in LUdcmp"
		end
		vv[i] = 1.0 / big;
	end

	for k = 1, n do
		big = 0.0;
		for i = k, n do
			temp = vv[i] * Math.Abs(lu[i, k]);
			if (temp > big) then
				big = temp;
				imax = i;
			end
		end

		if k ~= imax then
			for j = 1, n do
				temp = self.LU[imax][j];
				self.LU[imax][j] = self.LU[k][j];
				self.LU[k][j] = temp;
			end
			d = -d;
			vv[imax] = vv[k];
		end

		indx[k] = imax;

		if self.LU[k][k] == 0.0 then
			self.LU[k][k] = TINY;
		end

		for (i = k + 1; i < n; i++)
			temp = self.LU[i][k] /= self.LU[k][k];
			for (j = k + 1; j < n; j++) do
				self.LU[i][j] -= temp * self.LU[k][j];
			end
		end
	end
end

-- for one dimensional array
function LUdcmp.solve1D(double[] b, double[] x) -- b input and x output
        {
            int i, ii = 0, ip, j;
            double sum;

            if (b.Length != n || x.Length != n)
                throw new Exception("Bad sizes, must be square");

            for (i = 0; i < n; i++)
                x[i] = b[i];

            for (i = 0; i < n; i++)
            {
                ip = indx[i];
                sum = b[ip];
                x[ip] = x[i];
                if (ii != 0) for (j = ii - 1; j < i; j++) sum -= lu[i, j] * x[j];
                else if (sum != 0.0) ii = i + 1;
                x[i] = sum;
            }

            for (i = n - 1; i >= 0; i--)
            {
                sum = x[i];

                for (j = i + 1; j < n; j++)
                    sum -= lu[i, j] * x[j];

                x[i] = sum / lu[i, i];
            }
        }

-- for 2D array
function LUdcmp.solve2D(double[,] b, double[,] x) -- b input and x output
        {
            int i, j, m = b.GetLength(1);
            if (b.GetLength(0) != n || x.GetLength(0) != n || b.GetLength(1) != x.GetLength(1))
                throw new Exception("Bad sizes");

            double[] xx = new double[n];

            for (j = 0; j < m; j++)
            {
                for (i = 0; i < n; i++)
                    xx[i] = b[i, j];

                solve(xx, xx);

                for (i = 0; i < n; i++)
                    x[i, j] = xx[i];
            }
        }

function LUdcmp.inverse(self)
	ainv = createArray(n, n, 0)

	for (int i = 0; i < n; i++)
		ainv[i][i] = 1.0;
	end

	self:solve(ainv, ainv);

	return ainv;
end

function LUdcmp.det(self)
	local dd = self.d;

	for i = 1, n do
		dd = dd * self.LU[i][i];
	end

	return dd;
end

function LUdcmp.mprove(double[] b, double[] x)
        {
            int j, i;
            double sdp;
            double[] r = new Double[n];

            for (i = 0; i < n; i++)
            {
                sdp = -b[i];
                for (j = 0; j < n; j++) sdp += aref[i, j] * x[j];
                r[i] = sdp;
            }

            solve(r, r);

            for (i = 0; i < n; i++)
                x[i] -= r[i];
        }
    }
