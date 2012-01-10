local usteps = 180
local wsteps = 80
local radius = 5
local height = 10

local con = {{radius, 0, 0}, {0, 0, height}}
local cyl = {{radius, 0, 0}, {radius, 0, height}}
local hyp = {{radius, 0, 0}, {0, radius, height}}

function hyper(params)
	hyperboloid({
	USteps = usteps,
	WSteps = wsteps,
	StartPoint = params[1],
	EndPoint = params[2],
	--ColorSampler = checkerboard:new({Columns=usteps, Rows=wsteps})
	})
end

color("Red")
hyper(con)

color("Green")
translate({12, 0, 0})
hyper(cyl)

color("Blue")
translate({24, 0, 0})
hyper(hyp)