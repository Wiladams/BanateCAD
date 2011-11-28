-- The offset determines how big the hollow in the center of the torus is
-- The first entry is the offset along the y-axis
-- the second entry is the offset along the x-axis
offset = 20

-- The size determines the size of the cross section of the torus
-- First entry is the 'height' in the z-axis
-- Second entry is the 'width' along the x-axis
size = 6

usteps = 8	-- The is the resolution around the cross section
wsteps = 8	-- The resolution around the great ring

local colorSampler2 = ImageSampler.new({Filename='profile_1024_768.png'})
local colorSampler1 = ImageSampler.new({Filename='profile_80_60.png'})

torus({
	HoleRadius=offset,
	ProfileRadius=size,
	USteps = usteps,
	WSteps = wsteps,
	ColorSampler = checkerboard:new({Columns=usteps, Rows=wsteps})
	})

color(crayola.rgb("Blue Bell"))
translate({offset, 0, 0})
torus({
	HoleRadius=offset,
	ProfileRadius = size,
	USteps = usteps*10,
	WSteps = wsteps*10,
	ColorSampler = colorSampler1
	})

translate({offset, offset, 0})
torus({
	HoleRadius = offset,
	ProfileRadius = size,
	USteps = usteps*10,
	WSteps = wsteps*10,
	ColorSampler = colorSampler2
	})