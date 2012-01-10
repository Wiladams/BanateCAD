--require "Class"

--[[
// # class Vertex

// Represents a vertex of a polygon. Use your own vertex class instead of this
// one to provide additional features like texture coordinates and vertex
// colors. Custom vertex classes need to provide a `pos` property and `clone()`,
// `flip()`, and `interpolate()` methods that behave analogous to the ones
// defined by `CSG.Vertex`. This class provides `normal` so convenience
// functions like `CSG.sphere()` can return a smooth vertex normal, but `normal`
// is not used anywhere else.
--]]

--require "csg_vector"

Vertex = inheritsFrom(nil)

function Vertex.new(pos, normal)
	local new_inst = Vertex:create()

	new_inst.pos = Vector.new(pos)
	new_inst.normal = Vector.new(normal)

 	return new_inst
end

function Vertex.clone(this)
    return Vertex.new(this.pos:clone(), this.normal:clone())
end

-- Invert all orientation-specific data (e.g. vertex normal). Called when the
-- orientation of a polygon is flipped.
function Vertex.flip(this)
    this.normal = this.normal:negated();

	return this
end

-- Create a new vertex between this vertex and `other` by linearly
-- interpolating all properties using a parameter of `t`. Subclasses should
-- override this to interpolate additional properties.
function Vertex.interpolate(self, other, t)
    return Vertex.new(self.pos:lerp(other.pos, t), self.normal:lerp(other.normal, t))
end

function Vertex.tostring(v)
	return '{'..Vector.tostring(v.pos)..','..Vector.tostring(v.normal)..'}'
end



--[[

	local v1 = Vertex.new({1,1,1},{0,0,1})

	print(Vertex.tostring(v1))

	local v2 = v1:clone()
	print("v1 - V2 clone: ", v1:tostring(), v2:tostring())
--]]
