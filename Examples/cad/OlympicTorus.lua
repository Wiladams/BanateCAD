-- The offset determines how big the hollow in the center of the torus is
-- The first entry is the offset along the y-axis
-- the second entry is the offset along the x-axis
offset = 10

-- The size determines the size of the cross section of the torus
-- First entry is the 'height' in the z-axis
-- Second entry is the 'width' along the x-axis
size = 2

usteps = 90	-- The is the resolution around the cross section
wsteps = 180	-- The resolution around the great ring

local torii={
	{"Black", {offset*2+size*2.618, 0, 0}},
	{"Red", {0, 0, 0}},
	{"Blue", {-offset*2-size*2.618, 0, 0}},
	{"Yellow", {(-offset*2-size*2.618)/2, -offset, 0}},
	{"Green", {(offset*2+size*2.618)/2, -offset, 0}},
}

for _,t in ipairs(torii) do
	color(crayola.rgb(t[1]))
	translate(t[2])
	torus({
		HoleRadius=offset,
		ProfileRadius=size,
		USteps = usteps,
		WSteps = wsteps,
		})
end
