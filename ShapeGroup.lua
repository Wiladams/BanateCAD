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
	self.Members = params.Members or {}
end

function ShapeGroup.AddMember(self, newmember)
	table.insert(self.Members, newmember)
end


function ShapeGroup.RenderMembers(self, renderer)
	if self.Members == nil then return end

	for i=1,#self.Members do
		self.Members[i].Render()
	end
end

function ShapeGroup.RenderSelf(self, renderer)

end

function ShapeGroup.Render(self, renderer)
	self:RenderSelf(renderer)
	self:RenderMembers(renderer)
end

function ShapeGroup.ToString(self)
	return "ShapeGroup"
end

