-- The offset determines how big the hollow in the center of the torus is
-- The first entry is the offset along the y-axis
-- the second entry is the offset along the x-axis
offset = 10

-- The size determines the size of the cross section of the torus
-- First entry is the 'height' in the z-axis
-- Second entry is the 'width' along the x-axis
size = 6

usteps = 8	-- The is the resolution around the cross section
wsteps = 8	-- The resolution around the great ring

local colorSampler2 = ImageSampler({Filename='profile_1024_768.png'})
local colorSampler1 = checkerboard({Columns=usteps, Rows=wsteps})

function test_textured_torus()
torus({Offset=offset,
	ProfileRadius=size,
	USteps = usteps,
	WSteps = wsteps,
	ColorSampler = checkerboard({Columns=usteps, Rows=wsteps})
	})
end

function test_two_torii()
color(crayola.rgb("Blue Bell"))
translate({offset[2], 0, 0})
torus({Offset=offset,
	ProfileRadius=size,
	USteps = usteps*10,
	WSteps = wsteps*10,
	ColorSampler = ImageSampler({Filename='profile_1024_768.png'})
	})

local lshape = shape_torus({Offset=offset,
	ProfileRadius=size,
	USteps = usteps*8,
	WSteps = wsteps*6,
	ColorSampler = colorSampler1
	})

translate({offset, offset, 0})
addshape(lshape)
end

function test_partial_torus()
	color(crayola.rgb("Blue Bell"))

	local profiler = shape_ellipsoid({
		XRadius = 6,
		ZRadius = 7,
		})

	local seprofiler = param_superellipse({
		XRadius = 6,
		ZRadius = 3,
		N = 1.4,
		})

	local lshape = shape_torus({
		HoleRadius = offset,
		ProfileRadius = offset/4,
		--ProfileSampler = seprofiler,
		USteps = usteps*8,
		WSteps = wsteps*6,
		MinPhi = math.rad(30),
		MaxPhi = math.rad(220),	-- Great circle

		MinTheta = math.rad(0),
		MaxTheta = math.rad(360),	-- profile
		})
	addshape(lshape)
end

test_partial_torus()