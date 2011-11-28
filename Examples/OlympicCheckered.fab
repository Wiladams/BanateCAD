-- The offset determines how big the hollow in the center of the torus is
-- The first entry is the offset along the y-axis
-- the second entry is the offset along the x-axis
offset = 10

-- The size determines the size of the cross section of the torus
-- First entry is the 'height' in the z-axis
-- Second entry is the 'width' along the x-axis
size = 2

usteps = 24	-- The is the resolution around the cross section
wsteps = 24	-- The resolution around the great ring


color(crayola.rgb("Black"))
torus({
	HoleRadius=offset,
	ProfileRadius=size,
	USteps = usteps,
	WSteps = wsteps,
	ColorSampler = checkerboard:new({Columns=usteps, Rows=wsteps, LowColor={0,0,0,1}, HighColor={1,1,1,0}})
	})

color(crayola.rgb("Red"))
translate({offset*2+size*2.618, 0, 0})
torus({
	HoleRadius=offset,
	ProfileRadius=size,
	USteps = usteps,
	WSteps = wsteps,
	ColorSampler = checkerboard:new({Columns=usteps, Rows=wsteps, LowColor={1,0,0,1}, HighColor={1,1,1,0}})
	})

color(crayola.rgb("Blue"))
translate({-offset*2-size*2.618, 0, 0})
torus({
	HoleRadius=offset,
	ProfileRadius=size,
	USteps = usteps,
	WSteps = wsteps,
	ColorSampler = checkerboard:new({Columns=usteps, Rows=wsteps, LowColor={0,0,1,1}, HighColor={1,1,1,0}})
	})


color(crayola.rgb("Yellow"))
translate({(-offset*2-size*2.618)/2, -offset, 0})
torus({
	HoleRadius=offset,
	ProfileRadius=size,
	USteps = usteps,
	WSteps = wsteps,
	ColorSampler = checkerboard:new({Columns=usteps, Rows=wsteps, LowColor={1,1,0,1}, HighColor={1,1,1,0}})
	})

color(crayola.rgb("Green"))
translate({(offset*2+size*2.618)/2, -offset, 0})
torus({
	HoleRadius=offset,
	ProfileRadius=size,
	USteps = usteps,
	WSteps = wsteps,
	ColorSampler = checkerboard:new({Columns=usteps, Rows=wsteps, LowColor={0,1,0,1}, HighColor={1,1,1,0}})
	})
