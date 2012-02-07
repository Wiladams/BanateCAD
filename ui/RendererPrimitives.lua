-- RendererPrimitives.lua

local class = require "pl.class"

class.RendererPrimitives()

function RendererPrimitives:_init(params)
	self.FillColor = params.FillColor or Color(255)
	self.StrokeColor = params.StrokeColor or Color(0)
end
