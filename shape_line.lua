require ("Class")
require ("Shape")
require ("glsl")

shape_line = inheritsFrom(Shape)
function shape_line.new(params)
	local new_inst = shape_line.create()

	new_inst.Start = params.Start or {0,0,0}
	new_inst.End = params.End or {1,1,1}
	new_inst.Width = params.Width or 1

	new_inst.Transform = params.Transform or {}

	return new_inst
end

function shape_line.RenderSelf(self, renderer)
		renderer:DrawLine({self.Start, self.End, self.Width})
end


function shape_line.tostring(self)
	return "local lshape = shape_line.new({Start="..self.Start..", End="..self.End.."})"
end
