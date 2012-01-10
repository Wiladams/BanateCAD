local locations = {
	sanjose = {dmstodeg(37,20,21), dmstodeg(121,53,38)},
	sanantonio = {dmstodeg(29,25,26), dmstodeg(98,29,35)},
	chicago = {dmstodeg(41,51,0), dmstodeg(87,39,0)},
	amsterdam = {dmstodeg(52,21,0), dmstodeg(4,55,0)},
	dublin = {dmstodeg(53,19,59), dmstodeg(6,14,56)},
}

local GlobeRadius = 300
local Period = 30

-- Create a path on the surface
tracer = inheritsFrom(nil)
function tracer.new(params)
	local new_inst = tracer.create()

	new_inst.Radius = params.Radius or 1
	new_inst.Start = params.Start or {0,0, new_inst.Radius}
	new_inst.End = params.End or {0, math.pi, new_inst.Radius}

	return new_inst
end

function tracer.Eval(self, u)
	if  u <= 0.5 then
		local pos = lerp(self.Start, self.End, u*2)
		local xyz = sph_to_cart(pos)
		return xyz
	end

	local pos = lerp(self.Start, self.End, 2-u*2)
	local xyz = sph_to_cart(pos)

	return xyz
end


function createrunner(params)
	local lshape = shape_ellipsoid.new({XRadius=5, ZRadius=5})

	local atracer = tracer.new({
		Radius = GlobeRadius,
		Start = params.Start,
		End = params.End,
		})

	local pptransformer = ParamTransformer.new({
		TranslateFunctor = functor(atracer, atracer.Eval)
		})

	-- Create the shape animator
	local sanimator = ShapeAnimator.new({
		Shape = lshape,
		Transformer = pptransformer,
		Period = Period,
		})

	return sanimator
end

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
		XRadius=GlobeRadius,
		ZRadius = GlobeRadius,
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

local runner1 = createrunner({
	Start = sph(0, math.rad(35), GlobeRadius),
	End = sph(math.rad(360), math.rad(135), GlobeRadius),
	})

local runner2 = createrunner({
	Start = sph(20, math.rad(45), GlobeRadius),
	End = sph(math.rad(70), math.rad(90), GlobeRadius),
	})

local runner3 = createrunner({
	Start = sph(0, math.rad(0), GlobeRadius),
	End = sph(math.rad(180), math.rad(360), GlobeRadius),
	})

local runner4 = createrunner({
	Start = sph(math.rad(25), math.rad(70), GlobeRadius),	-- Hawaii
	End = sph(math.rad(60), math.rad(55), GlobeRadius),		-- San Jose
	})

-- Set the color scheme to "Space"
defaultviewer.colorscheme = colorschemes.Space

-- Create the Sphere that will be traced upon
--sphere(GlobeRadius)
displayearth()

addshape(runner1)
addshape(runner2)
addshape(runner3)
addshape(runner4)

