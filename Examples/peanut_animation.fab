panimator = inheritsFrom(Shape)
function panimator.new(params)
	local new_inst = panimator.create()

	new_inst.Balls = {{0,0,0,5}, {0, 1, 16, 5}}
	new_inst.Radius = 100
	new_inst.Threshold = 0.001

	new_inst.Isosurface = 	shape_metaball.new({
		balls = new_inst.Balls,
		radius = new_inst.Radius,
		Threshold = new_inst.Threshold,

		USteps = 30,
		WSteps = 30,
	})

	return new_inst
end

function panimator.RenderSelf(self, renderer)
	renderer:DisplayMesh(self.Isosurface:GetMesh(), false)
end

function panimator.Update(self, toTime)
	local period = 40
	local frac = mod(toTime, period)/period

	local anifrac = frac
	if (frac < 0.5) then
		anifrac = frac * 2
	else
		anifrac = 2 - frac*2
	end

	self.Threshold = 0.001
	local balls = {{0,0,0,5}, {0, 1, 19*anifrac, 5*anifrac}}

	self.Isosurface = 	shape_metaball.new({
		balls = balls,
		radius = self.Radius,
		Threshold = self.Threshold,

		USteps = 20,
		WSteps = 20,
	})
end


-- Add our shape to the scene
local pan = panimator.new()
addshape(pan)