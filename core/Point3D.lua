local class = require "pl.class"

class.Point3D()


function Point3D:_init(...)
	--self:delegate(Point3D)

	if arg.n == 0 then
		-- default constructor
		self[1] = 0
		self[2] = 0
		self[3] = 0
		self[4] = 1
	elseif arg.n == 2 then
		-- Three discreet arguments
		self[1] = arg[1]
		self[2] = arg[2]
		self[3] = 0
		self[4] = 1
	elseif arg.n == 3 then
		-- Three discreet arguments
		self[1] = arg[1]
		self[2] = arg[2]
		self[3] = arg[3]
		self[4] = 1
	elseif arg.n == 1 and type(arg[1]) == "table" then
		-- Single argument that is a table
		self[1] = arg[1][1];
		self[2] = arg[1][2];
		self[3] = arg[1][3] or 1;
		self[4] = 1
	end
end

function Point3D.clone(self)
	local new_inst = Point3D(self)

	return new_inst
end


-- Arithmetic overloads
function Point3D.__add(a, b)
	if type(a) == "table" and type(b) == "table" then
		return Point3D(a[1]+b[1], a[2]+b[2], a[3]+b[3])
	end

	return nil
end

function Point3D.__sub(a, b)
	if type(a) == "table" and type(b) == "table" then
		return Point3D(a[1]-b[1], a[2]-b[2], a[3]-b[3])
	end

	return nil
end

function Point3D.mults(v,s)
	local res = Point3D(v[1]*s, v[2]*s, v[3]*s)

	return res
end

function Point3D.__mul(a, b)
	local res = Point3D()
	local bnumber = type(b) == 'number'
	local anumber = type(a) == 'number'

	if bnumber then
		res[1] = a[1] * b
		res[2] = a[2] * b
		res[3] = a[3] * b
	elseif anumber then
		res[1] = b[1] * a
		res[2] = b[2] * a
		res[3] = b[3] * a
	else
		res[1] = a[1] * b[1]
		res[2] = a[2] * b[2]
		res[3] = a[3] * b[3]
	end

	return res
end

function Point3D.__div(a, b)
	local res = Point3D()
	local bnumber = type(b) == 'number'
	local anumber = type(a) == 'number'

	if bnumber then
		res[1] = a[1] / b
		res[2] = a[2] / b
		res[3] = a[3] / b
	elseif anumber then
		res[1] = b[1] / a
		res[2] = b[2] / a
		res[3] = b[3] / a
	else
		res[1] = a[1] / b[1]
		res[2] = a[2] / b[2]
		res[3] = a[3] / b[3]
	end

	return res
end

function Point3D.__unm(self)
	local res = Point3D(-self[1], -self[2], -self[3])

	return res
end

-- Linear Algebra Functions

function Point3D.lerp(self, a, t)
    return self + ((a - self) * t)
end

-- Convenience functions
--[[
function Point3D.__tostring (self)
      local s = "{"
      local sep = ""
      for i=1,#self do
        s = s .. sep .. self[i]
        sep = ", "
      end
      return s .. "}"
end
--]]

--[[
	The natural storage of the Point information is
	as indexed table entries.  This allows the entries
	to be easily accessed using [] notation.

	Sometimes, we want to access the values using nice
	field names, like point.x, point.y

	So, we have swizzling.  this allows you to assign
	more interesting names to fields, while maintaining
	their simple storage mechanism.
--]]
function Point3D_swizzler(tbl, key)
print(tbl, key, type(key))
print(#tbl)
	-- Most of the time, we'll be doing lookup
	-- based on a numeric index value.  So,
	-- We'll try that first
--[[
	if type(key) == "number" then
		-- for Homogenous coordinates
		-- The 4th entry of a point is always '1'
		-- we don't need to store it, but we need to return it
		-- This will make it work for matrix math
		if key == 4 then return 1 end

		return rawget(t, key)
	end
--]]


	-- If it wasn't an index lookup, and it wasn't a function
	-- It must be a lookup of a field by field name
	if key == "x" then return rawget(tbl, 1) end
	if key == "y" then return rawget(tbl, 2) end
	if key == "z" then return rawget(tbl, 3) end
	if key == "w" then return 1 end

	return nil
end

-- Setup the meta methods
--Point3D.catch(Point3D_swizzler)

Point3D.Zero = Point3D()






--[[
print("Point3D.lua")
local pt = Point3D(10,20, 30)

--print(pt.x)
print("pt: ", pt)
print(#pt)
print("1: ", pt[1])

local x = pt.x

--Quick Tests
v1 = Point3D(1,0,0)
v2 = Point3D(2,3, 4)
vX = Point3D(1, 0, 0)
vY = Point3D(0,1,0)

print(v1[1], v1[2], v1[3])


v3 = v1 + v2
v4 = v1 - v2

print("V3: ", v3)
print(v4)

v5 = v2 * 2
v6 = 2 * v2

print(v5)
print(v6)

print(v6/2)

print(-v2)


print("Lerp: ", v1:lerp(v2, 0.5))

print("Homogenous: ", v1[4])
--]]

return Point3D
