function displayearth()
	size={80,60}
	res = {1,1}


	local texturesampler = ImageSampler.new({
		--Filename='moonbumpmap2_720_360.png',
		Filename='earthcolor_800_400.png',
		Size = size,
		Resolution = res,
		MaxHeight=16,
	})

	local heightsampler = ImageSampler.new({
		--Filename='moonbumpmap2_720_360.png',
		Filename='earthheight_800_400.png',
		Size = size,
		Resolution = res,
		MaxHeight=16,
	})

	local vertsampler = shape_ellipsoid.new({
		XRadius=60, 
		ZRadius = 60,
		MaxTheta = math.rad(360),
		MaxPhi = math.rad(180),
	})

	local dispSampler = DisplacementSampler.new({
			VertexSampler = vertsampler,
			HeightSampler = heightsampler,
			MaxHeight = 4,
		})

	local lshape =  BiParametric.new({
		USteps = 800/2,
		WSteps = 400/2,
		ColorSampler = texturesampler,
		VertexFunction=dispSampler,
		--Thickness = -2,
		})

color("Silver")
	addshape(lshape)
end

function displayMoon()
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
		MaxTheta = math.rad(360),
		MaxPhi = math.rad(180),
	})

	local dispSampler = DisplacementSampler.new({
			VertexSampler = vertsampler,
			HeightSampler = heightsampler,
			MaxHeight = .75,
		})

	local lshape =  BiParametric.new({
		USteps = 720/2,
		WSteps = 360/2,
		ColorSampler = heightsampler,
		VertexFunction=dispSampler,
		--Thickness = -2,
		})

	addshape(lshape)
end

displayearth()

local moonpos = sph_to_cart({math.rad(30), math.rad(70), 170})
translate(moonpos)
displayMoon()

defaultviewer.colorscheme = colorschemes.Space