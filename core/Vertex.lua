--require "Vector3D"

Vertex = {}
Vertex_mt = {__index = Vertex}


function Vertex.new(pos, normal)
	local this = {}
	setmetatable(this, Vertex_mt)

	this.pos = Vector3D.new(pos)
	this.normal = Vector3D.new(normal)

 	return this
end

function Vertex.clone(this)
    return Vertex.new(this.pos:clone(), this.normal:clone())
end

-- Invert all orientation-specific data (e.g. vertex normal). Called when the
-- orientation of a polygon is flipped.
function Vertex.flip(this)
    this.normal = -this.normal -- :negated();

	return this
end

-- Create a new vertex between this vertex and `other` by linearly
-- interpolating all properties using a parameter of `t`. Subclasses should
-- override this to interpolate additional properties.
function Vertex.interpolate(self, other, t)
    return Vertex.new(self.pos:lerp(other.pos, t), self.normal:lerp(other.normal, t))
end

function Vertex.tostring(v)
	return '{'..v.pos:tostring()..','..v.normal:tostring()..'}'
end

-- Setup tostring
Vertex_mt.__tostring = Vertex.tostring


--[[

	local v1 = Vertex.new({1,1,1},{0,0,1})

	print(v1)

	local v2 = v1:clone()
	print("v1 - V2 clone: ", v1, v2)
--]]
