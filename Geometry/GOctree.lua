require ("Shape")

GOctree = GAABBox:new()

function GOctree:new(o)
	o = o or {} 		-- create object if user does not provide one
	o.Origin= o.Origin or {0,0,0}
	o.Extent= o.Extent or {1,1,1}
	o.Dimensions= o.Dimensions or {1,1,1}

	self.LowerVertex = o.Origin
	self.HigherVertex = v2
	self.Dimensions = {v2[1]-v1[1], v2[2]-v1[2], v2[3]-v1[3]}


	return self
end

function GOctree.RenderSelf(self, renderer)
	for _,e in ipairs(self.Edges) do
		renderer:DrawLine({self.Vertices[e[1]], self.Vertices[e[2]], 1})
	end
end

