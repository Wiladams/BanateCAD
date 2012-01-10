--	scale([10,10,10])
--[[
supershape({
		shape1={m=4, n1=0.5, n2=0.5, n3=4, a=1, b=1},
		shape2={m=4, n1=0.5, n2=0.5, n3=4, a=1, b=1},
		phisteps = 64,
		thetasteps = 32}
		)
--]]

-- Sphere

--[[
PolyMesh_print(f,RenderSuperShape(
	supershape(0, 1, 1, 1, 10, 1),
	supershape(0, 1, 1, 1, 1, 1),
	40,
	40))
--]]

--[[
PolyMesh_print(f,RenderSuperShape(
		supershape(5, 1, 1, 1, 1, 1),
		supershape(0, 1, 1, 1, 1, 1),
		32,
		128))
--]]


--[[
PolyMesh_print(f,RenderSuperShape(
		supershape(5.7, 0.5, 1, 2.5, 1, 1),
		supershape(10, 3, 0.2, 1, 1, 1),
		256,
		128))
--]]

--[[
PolyMesh_print(f,RenderSuperShape(
		supershape(0, 0.479398, 30.2539, 0.3563, 1, 1),
		supershape(5, 15.4425, -0.453763, 87.07, 1, 1),
		512,
		16))
--]]

-- Flipper / pastry scraper
--[[
supershape({
		shape1 = {m=1, n1=0.3, n2=0.3, n3=0.3, a=1, b=1},
		shape2 = {m=5, n1=15.4425, n2=-0.453763, n3=87.07, a=1, b=1},
		phisteps = 180,
		thetasteps =180
		})
--]]

-- Funky shape
color(crayola.rgb("Jazzberry Jam"))
supershape({
		shape1 = {m = 7, n1 = 0.2, n2 = 1.7, n3 = 1.7, a = 1, b = 1},
		shape2 = {m = 7, n1 = 0.2, n2 = 1.7, n3 = 1.7, a = 1, b = 1},
		phisteps = 180,
		thetasteps = 180
		})


--[[
PolyMesh_print(f,RenderSuperShape(
		supershape(9.0, -89.25, 0.41, -31.90, 1, 1),
		supershape(4.0, 100, 1000, 1000, 1, 1),
		64,
		64))
--]]