--require ("Class")
--require ("Shape")

ShapeAnimator = inheritsFrom(Shape)
function ShapeAnimator.new(params)
	local new_inst = ShapeAnimator.create()

	new_inst.Shape = params.Shape
	new_inst.Transformer = params.Transformer
	new_inst.Period = params.Period or 30

	return new_inst
end

function ShapeAnimator.RenderSelf(self, renderer)
	self.Shape:Render(renderer)
end

function ShapeAnimator.Update(self, toTime)
	if self.Transformer ~= nil then
		local u = mod(toTime, self.Period)/self.Period
		local atrans = self.Transformer:GetTransform(u)
		self:SetTransform(atrans)
	end
end
