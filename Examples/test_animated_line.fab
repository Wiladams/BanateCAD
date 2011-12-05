-- Create an ellipsoid function

animated_line = inheritsFrom(Shape)
function animated_line.new(params)
	local new_inst = animated_line.create()

	new_inst.Start = params.Start or {0,0,0}
	new_inst.End = params.End or {1,1,1}
	new_inst.Width = params.Width or 1

	new_inst.Transform = params.Transform or {}

	return new_inst
end

function animated_line.RenderSelf(self, renderer)
		renderer:DrawLine({self.Start, self.End, self.Width})
end

function animated_line.Update(self, toTime)
	local offset = mod(toTime, 15)*2
	self.Transform.Translation = {offset, offset, offset}
--	print("Line.Update: ", toTime)
end

local lshape = animated_line.new({
	Start = {0,0,0},
	End = {10,10,10},
	Width = 3,
	})

color("Red")
addshape(lshape)
