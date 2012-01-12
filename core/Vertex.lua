--require "Vector3D"
local class = require "pl.class"

class.Vertex()


function Vertex:_init(pos, normal)
	self.pos = Vector3D.new(pos)
	self.normal = Vector3D.new(normal)
end

function Vertex.clone(self)
    return Vertex(this.pos:clone(), this.normal:clone())
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
