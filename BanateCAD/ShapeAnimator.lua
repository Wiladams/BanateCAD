--require ("Class")
--require ("Shape")
local class = require "pl.class"

class.ShapeAnimator(Shape)

function ShapeAnimator:_init(params)
	self.Shape = params.Shape
	self.Transformer = params.Transformer
	self.Period = params.Period or 30
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
