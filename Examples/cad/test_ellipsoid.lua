function concentric_ellipse()
	color({1, 0, 0,1})
	ellipsoid(1,1)

	color({0.75, 0.75, 0.75, 0.5})
	ellipsoid(2,3)

	color({0.75, 1, 0.75, 0.5})
	ellipsoid(6,4)
end

function partial()
local lshape = shape_ellipsoid({
	XRadius=10,
	YRadius=10,
	USteps=360/8,
	WSteps=360/8,
	MaxPhi = math.rad(120),
	MaxTheta = math.rad(270),
	})

	addshape(lshape)
end

function show_verts()
	local lshape = shape_ellipsoid({
		XRadius=10,
		ZRadius=15,
		USteps=360/8,
		WSteps=360/8,
		Thickness = -2,
		MaxPhi = math.rad(120),	-- latitude
		MaxTheta = math.rad(270),	-- around z axis
	})

	addshape(lshape)
end

function bumpy_ellipse()
	size={80,60}
	res = {1,1}

	local checksampler = checkerboard({
		Columns=(size[1]/2)+1,
		Rows=size[2]/2,
		LowColor={0,0,0,1},
		HighColor={1,1,1,1}
		})


	local vertsampler = shape_ellipsoid({
		XRadius=30,
		ZRadius = 30,
		MaxTheta = math.rad(360),
		MaxPhi = math.rad(360),
	})

	local dispSampler = DisplacementSampler.new({
			VertexSampler = vertsampler,
			HeightSampler = checksampler,
			MaxHeight = 1,
		})

	local lshape =  BiParametric({
		USteps = 720,
		WSteps = 360,
		VertexFunction=dispSampler,
		Thickness = -2,
		})

	addshape(lshape)

end

--color("Caribbean Green")
color("Silver")
--show_verts()
--concentric_ellipse()
bumpy_ellipse()
