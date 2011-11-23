offset = 0
radius = 50
iradius = 20
maxangle = 180
resolution = 18

local lshape = shape_disk:new({
		Offset=offset,
		Radius=radius,
		InnerRadius=iradius,
		PhiMax=math.rad(maxangle),
		Resolution={resolution,2}
		})

	defaultscene:appendCommand(CADVM.mesh(lshape:GetMesh()))
