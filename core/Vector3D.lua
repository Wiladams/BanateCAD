local class = require "pl.class"

-- This is the cheapest way to setup a 'class'
class.Vector3D()

function Vector3D:_init(...)

	if arg.n == 3 then
		-- Three discreet arguments
		self[1] = arg[1]
		self[2] = arg[2]
		self[3] = arg[3]
		self[4] = 0
	elseif arg.n == 1 and type(arg[1]) == "table" then
		-- Single argument that is a table
		self[1] = arg[1][1];
		self[2] = arg[1][2];
		self[3] = arg[1][3];
		self[4] = 0
	end
end

function Vector3D.clone(self)
	local new_inst = Vector3D(self)

	return new_inst
end

-- Arithmetic overloads
function Vector3D.__add(a, b)
	if type(a) == "table" and type(b) == "table" then
		return Vector3D.new{a[1]+b[1], a[2]+b[2], a[3]+b[3]}
	end

	return nil
end

function Vector3D.__sub(a, b)
	if type(a) == "table" and type(b) == "table" then
		return Vector3D.new{a[1]-b[1], a[2]-b[2], a[3]-b[3]}
	end

	return nil
end

function Vector3D.mults(v,s)
	local res = Vector3D.new({v[1]*s, v[2]*s, v[3]*s})

	return res
end

function Vector3D.__mul(a, b)
	local res = {}
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

	return Vector3D(res)
end

function Vector3D.__div(a, b)
	local res = {}
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

	return Vector3D(res)
end

function Vector3D.__unm(this)
	local res = Vector3D(-this[1], -this[2], -this[3])

	return res
end

-- Linear Algebra Functions




function Vector3D.lengthsquared(this)
	local sum = 0
	for i=1,#x do
		sum = sum + (x[i]*x[i])
	end

	return sum
end

function Vector3D.length(x)
	local sum = 0
	for i=1,#x do
		sum = sum + (x[i]*x[i])
	end

	local f = math.sqrt(sum)

	return f
end

function Vector3D.unit(this)
    return this / this:length()
end

function Vector3D.dot(this, a)
    return this[1] * a[1] + this[2] * a[2] + this[3] * a[3];
end

function Vector3D.cross(this, a)
    return Vector3D.new({
      this.y * a.z - this.z * a.y,
      this.z * a.x - this.x * a.z,
      this.x * a.y - this.y * a.x}
    )
end

function Vector3D.lerp(this, a, t)
    return this + ((a - this) * t)
end

-- Convenience functions
function Vector3D.__tostring (self)
      local s = "{"
      local sep = ""
      for i=1,#self do
        s = s .. sep .. self[i]
        sep = ", "
      end
      return s .. "}"
end

function Vector3D_swizzler(t, key)
	-- Most of the time, we'll be doing lookup
	-- based on a numeric index value.  So,
	-- We'll try that first
	if type(key) == "number" then
		-- The 4th entry of a vector is always '0'
		-- we don't need to store it, but we need to return it
		if key == 4 then return 0 end

		return rawget(t, key)
	end

	-- Next, we'll see if it's a function
	-- If it is, then we'll just return that function
	local func = Vector3D[key]
	if func ~= nil then return func end


	-- If it wasn't an index lookup, and it wasn't a function
	-- It must be a lookup of a field by field name
	if key == "x" then return rawget(t, 1) end
	if key == "y" then return rawget(t, 2) end
	if key == "z" then return rawget(t, 3) end

	return nil
end


-- Setup the meta methods
--Vector3D_mt.__index = Vector3D_swizzler
--Vector3D.mt.__index = Vector3D
--Vector3D_mt.__unm = Vector3D.neg
--Vector3D_mt.__tostring = Vector3D.tostring

Vector3D.Zero = Vector3D(0,0,0)







--[[
print("Vector3D.lua")
--Quick Tests
v1 = Vector3D.new{1,0,0}
v2 = Vector3D.new{2,3, 4}
vX = Vector3D.new{1, 0, 0}
vY = Vector3D.new{0,1,0}

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

return Vector3D
