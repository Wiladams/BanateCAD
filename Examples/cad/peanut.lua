function peanut_bumped()
	--local pballs = {{0, -2, -13,4}, {0,0,0,3}, {0, 1, 14, 4}}
	local pballs = {{0,0,0,5}, {0, 1, 16, 5}}

	local texturesampler = ImageSampler.new({
		Filename='PeanutTexture_200_200.png',
		Size = size,
		Resolution = res,
		MaxHeight=16,
	})

	local heightsampler = ImageSampler.new({
		Filename='PeanutTexture_200_200.png',
		Size = {200,200},
		Resolution = {1,1},
		MaxHeight=16,
	})

	local vertsampler = shape_metaball.new({
		balls = pballs,
		radius = 60,
	})

	local dispSampler = DisplacementSampler.new({
			VertexSampler = vertsampler,
			HeightSampler = heightsampler,
			MaxHeight = 1.5,
		})

	local lshape =  BiParametric.new({
		USteps = 200,
		WSteps = 200,
		ColorSampler = texturesampler,
		VertexFunction=dispSampler,
		--Thickness = -2,
		})

	addshape(lshape)
end

-- If you just want to see the blob with a texture
-- map on it, but without the bump map
-- do the following

function peanut_textured()
	local pballs = {{0, -2, -13,4}, {0,0,0,3}, {0, 1, 14, 4}}

	local texturesampler = ImageSampler.new({
		Filename='PeanutTexture_200_200.png',
		Size = size,
		Resolution = res,
		MaxHeight=16,
	})


	local apeanut = shape_metaball.new({
		balls = pballs,
		radius = 60,

		USteps = 200/4,
		WSteps = 200/4,
		ColorSampler = texturesampler,
	})

	color(crayola.rgb("Purple"))
	for _,v in ipairs(pballs) do
		translate(v)
		sphere(v[4])
	end

	color(crayola.rgba("Almond", 0.65))
	addmesh(apeanut:GetMesh())
end

peanut_bumped()
--peanut_textured()