
-- This is the cheapest way to setup a 'class'
Point3D = {}
Point3D_mt = {}

function Point3D.new(...)
	local this = {}
	setmetatable(this, Point3D_mt)

	if arg.n == 3 then
		-- Three discreet arguments
		this[1] = arg[1]
		this[2] = arg[2]
		this[3] = arg[3]
	elseif arg.n == 1 and type(arg[1]) == "table" then
		-- Single argument that is a table
		this[1] = arg[1][1];
		this[2] = arg[1][2];
		this[3] = arg[1][3];
	end

	return this
end

function Point3D.clone(this)
	local new_inst = Point3D.new(this)

	return new_inst
end

-- Arithmetic overloads
function Point3D.add(a, b)
	if type(a) == "table" and type(b) == "table" then
		return Point3D.new{a[1]+b[1], a[2]+b[2], a[3]+b[3]}
	end

	return nil
end

function Point3D.sub(a, b)
	if type(a) == "table" and type(b) == "table" then
		return Point3D.new{a[1]-b[1], a[2]-b[2], a[3]-b[3]}
	end

	return nil
end

function Point3D.mults(v,s)
	local res = Point3D.new({v[1]*s, v[2]*s, v[3]*s})

	return res
end

function Point3D.mul(a, b)
	local res = Point3D.new{}
	local bnumber = type(b) == 'number'
	local anumber = type(a) == 'number'

	if bnumber then
		for i=1,#a do
			local f = a[i] * b
			table.insert(res, f)
		end
	elseif anumber then
		for i=1,#b do
			local f = b[i] * a
			table.insert(res, f)
		end
	else
		for i=1,#a do
			local f = a[i] * b[i]
			table.insert(res, f)
		end
	end

	return res
end

function Point3D.div(a, b)
	local res = Point3D.new{}
	local bnumber = type(b) == 'number'
	local anumber = type(a) == 'number'

	if bnumber then
		for i=1,#a do
			local f = a[i] / b
			table.insert(res, f)
		end
	elseif anumber then
		for i=1,#b do
			local f = b[i] / a
			table.insert(res, f)
		end
	else
		for i=1,#a do
			local f = a[i] / b[i]
			table.insert(res, f)
		end
	end

	return res
end

function Point3D.neg(this)
	local res = Point3D.new({-this[1], -this[2], -this[3]})

	return res
end

-- Linear Algebra Functions

function Point3D.lerp(this, a, t)
    return this + ((a - this) * t)
end

-- Convenience functions
function Point3D.tostring (self)
      local s = "{"
      local sep = ""
      for i=1,#self do
        s = s .. sep .. self[i]
        sep = ", "
      end
      return s .. "}"
end

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
function Point3D_swizzler(t, key)
	-- Most of the time, we'll be doing lookup
	-- based on a numeric index value.  So,
	-- We'll try that first
	if type(key) == "number" then
		-- for Homogenous coordinates
		-- The 4th entry of a point is always '1'
		-- we don't need to store it, but we need to return it
		-- This will make it work for matrix math
		if key == 4 then return 1 end

		return rawget(t, key)
	end

	-- Next, we'll see if it's a function
	-- If it is, then we'll just return that function
	local func = Point3D[key]
	if func ~= nil then return func end


	-- If it wasn't an index lookup, and it wasn't a function
	-- It must be a lookup of a field by field name
	if key == "x" then return rawget(t, 1) end
	if key == "y" then return rawget(t, 2) end
	if key == "z" then return rawget(t, 3) end
	if key == "w" then return 1 end

	return nil
end


-- Setup the meta methods
Point3D_mt.__index = Point3D_swizzler
--Point3D.mt.__index = Point3D
Point3D_mt.__add = Point3D.add
Point3D_mt.__div = Point3D.div
Point3D_mt.__sub = Point3D.sub
Point3D_mt.__mul = Point3D.mul
Point3D_mt.__unm = Point3D.neg
Point3D_mt.__tostring = Point3D.tostring

Point3D.Zero = Point3D.new({0,0,0})







--[[
print("Point3D.lua")
--Quick Tests
v1 = Point3D.new{1,0,0}
v2 = Point3D.new{2,3, 4}
vX = Point3D.new{1, 0, 0}
vY = Point3D.new{0,1,0}

print(v1.x, v1.y, v1.z)

print("Length v1: ", v1:length())
print("Length v2: ", v2:length())

print("Unit v1: ", v1:unit())
print("Unit v2: ", v2:unit())

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

local vZ = vX:cross(vY)
print("Cross: ", vZ)

print("Lerp: ", vZ:lerp(vX, 0.5))

print("Homogenous: ", v1[4])
--]]

