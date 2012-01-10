	size={80,60}
	res = {1,1}


	local heightsampler = ImageSampler.new({
		Filename='moonbumpmap2_720_360.png',
		Size = size,
		Resolution = res,
		MaxHeight=16,
	})

	local vertsampler = shape_ellipsoid.new({
		XRadius=30, 
		ZRadius = 30,
		MaxTheta = math.rad(360),	-- Make this less to crack it open along latitude
		MaxPhi = math.rad(180),	-- Make this less to crack it open along longitude
	})

	local dispSampler = DisplacementSampler.new({
			VertexSampler = vertsampler,
			HeightSampler = heightsampler,
			MaxHeight = 2.5,
		})

	local lshape =  BiParametric.new({
		USteps = 720/4,	-- Divide by smaller number to get more detail
		WSteps = 360/4,	-- Divide by smaller number to get more detail
		ColorSampler = heightsampler,
		VertexFunction=dispSampler,
		--Thickness = -2,
		})

color("Silver")
	addshape(lshape)