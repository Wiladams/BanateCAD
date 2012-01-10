
--[[
// # class Vector

// Represents a 3D vector.
//
// Example usage:
//
//     new CSG.Vector(1, 2, 3);
//     new CSG.Vector([1, 2, 3]);
//     new CSG.Vector({ x: 1, y: 2, z: 3 });
--]]

--require ("Class")


Vector = inheritsFrom(nil)
--Vector = {}

function Vector.new(...)
--	local this = {}
--	local this_mt = {__index = this}
--	setmetatable(this, this_mt)

	this = Vector:create()

	if arg.n == 3 then
		-- Three discreet arguments
		this.x = arg[1]
		this.y = arg[2]
		this.z = arg[3]
	elseif (arg.n == 1 and arg[1].x ~= nil) then
		-- Single argument that is a table
		-- with named values
		this.x = arg[1].x;
		this.y = arg[1].y;
		this.z = arg[1].z;
	else
		-- Single argument that is assumed
		-- to be a table, without names
		this.x = arg[1][1]
		this.y = arg[1][2]
		this.z = arg[1][3]
	end

	return this
end

function Vector.clone(this)
    return Vector.new(this.x, this.y, this.z)
end

function Vector.negated(this)
    return Vector.new(-this.x, -this.y, -this.z);
end

function Vector.plus(this, a)
    return Vector.new(this.x + a.x, this.y + a.y, this.z + a.z);
end

function Vector.minus(this, a)
    return Vector.new(this.x - a.x, this.y - a.y, this.z - a.z)
end

function Vector.times(this, a)
    return Vector.new(this.x * a, this.y * a, this.z * a);
end

function Vector.dividedBy(this, a)
    return Vector.new(this.x / a, this.y / a, this.z / a);
end


function Vector.dot(this, a)
    return this.x * a.x + this.y * a.y + this.z * a.z;
end

function Vector.lerp(this, a, t)
    return this:plus(a:minus(this):times(t))
end

function Vector.length(this)
    return math.sqrt(this:dot(this))
end

function Vector.unit(this)
    return this:dividedBy(this:length())
end

function Vector.cross(this, a)
    return Vector.new(
      this.y * a.z - this.z * a.y,
      this.z * a.x - this.x * a.z,
      this.x * a.y - this.y * a.x
    )
end

function Vector.tostring(v)
	return '{'..v.x..','..v.y..','..v.z..'}'
end


--[[
local v1 = Vector.new({1,2,3})

print(v1.x, v1.y, v1.z)

local v2 = Vector.new(3,4,5)
print(v2.x, v2.y, v2.z)

local v3 = Vector.new(v2)
print (v3:tostring())

local v4 = v2:clone()
print("V2 - V4: ", v2:tostring(), v4:tostring())
--]]
