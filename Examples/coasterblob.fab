local side = 20
local radius = 4
local anifrac = 0.95


local balls = {
		{side,side,lerp(0, side, anifrac),radius}, 
		{-side,side, lerp(0, side, anifrac), radius}, 
		{-side,-side, lerp(0, side, anifrac), radius}, 
		{side,-side, lerp(0, side, anifrac), radius}, 

		{side,side,lerp(0, side+side, anifrac),radius}, 
		{-side,side, lerp(0, side+side, anifrac), radius}, 
		{-side,-side, lerp(0, side+side, anifrac), radius}, 
		{side,-side, lerp(0, side+side, anifrac), radius}, 

		}

--local balls = {
--	{0,0,0,3},
--	{0,0,5,3}
--}

local lshape = shape_metaball.new({
		balls = balls,
		radius = 200,
		Threshold = 0.00001,

		USteps = 30,
		WSteps = 30,
	})

--addshape(lshape)
blobs(balls, 200, 60, 60)
