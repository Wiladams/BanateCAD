usteps = 36
wsteps = 24
scale({5,5,10})
translate({0,0,0})
hyperboloid({
	USteps = usteps,
	WSteps = wsteps,
	StartPoint = {1,0,0},
	EndPoint = {0, 1, 1},
	ColorSampler = checkerboard:new({Columns=usteps, Rows=wsteps})
	})

translate({0,0,13})
color("Red")
ellipsoid(4,5.5)

color("Caribbean Green")
translate({15, 0, 7})
sphere(5)

translate({15,0,0})
color("Purple")
paraboloid({
	USteps = usteps,
	WSteps = wsteps,
	ZMin = 0,
	ZMax = 10,
	RadiusMax = 8,
	})

color("Yellow")
translate({-15, 0, 0})
cone(5, 4, 10)

function rainbow(radius)
	color("Red")
	disk(radius, 15, 180)

	color("Green")
	disk(radius-5, radius-10, 180)

	color("Blue")
	disk(radius-10, 5, 180)


end

rainbow(20)