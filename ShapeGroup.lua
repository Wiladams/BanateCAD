require ("Class")
require ("Shape")

-- Create a base class, Shape
ShapeGroup = inheritsFrom(Shape);

function ShapeGroup.new(params)
	local new_inst = ShapeGroup.create()
	new_inst:Init(params)

	return new_inst
end

function shapeGroup.Init(self, params)
	self.Children = params.Children or {}
end

function ShapeGroup.RenderChildren(self, renderer)
	if self.Children == nil then return end

	for i=1,#self.Children do
		self.Children[i].Render()
	end
end

function ShapeGroup.RenderSelf(self, renderer)

end

function ShapeGroup.Render(self, renderer)
	self:RenderSelf(renderer)
	self:RenderChildren(renderer)
end

function ShapeGroup.ToString(self)
	return "ShapeGroup"
end

