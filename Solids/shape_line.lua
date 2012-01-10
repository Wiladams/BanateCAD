

local class = require "pl.class"

class.shape_line(Shape)

function shape_line:_init(params)
	params = params or {}

	self.Start = params.Start or {0,0,0}
	self.End = params.End or {1,1,1}
	self.Width = params.Width or 1

	self.Transform = params.Transform or {}

	return new_inst
end

function shape_line.RenderSelf(self, renderer)
	renderer:DrawLine({self.Start, self.End, self.Width})
end

function shape_line.__tostring(self)
	return "shape_line"
end


---[[
local sl = shape_line({Start = {0,0}, End = {10,10}})
print(sl)
--]]
