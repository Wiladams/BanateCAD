usteps = 24
wsteps = 32

color("Purple")
paraboloid({
	USteps = usteps,
	WSteps = wsteps,
	ZMin = 0,
	ZMax = 13,
	RadiusMax = 3,
	ColorSampler = checkerboard:new({Columns=usteps, Rows=wsteps})
	})

--color("Red")
--sphere(6)