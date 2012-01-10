--host.bgcolor = {0.9, 0.90, 0.40, 1}
--host.wirecolor = {1, 1, 1, 1}

-- Scraper

scraper = shape_supershape:new({name='Scraper',
	shape1 = superformula:new({m=1, n1=0.3, n2=0.3, n3=0.3, a=1, b=1}),
	shape2 = superformula:new({m=5, n1=15.4425, n2=-0.453763, n3=87.07, a=1, b=1}),
	phisteps = 32,
	thetasteps = 32})

-- Funky shape
funky = shape_supershape:new({name='Funky',
	shape1 = superformula:new({m=7, n1=0.2, n2=1.7, n3=1.7, a=1, b=1}),
	shape2 = superformula:new({m=7, n1=0.2, n2=1.7, n3=1.7, a=1, b=1}),
	phisteps = 64,
	thetasteps = 64})


-- Octahedron
oocta = shape_supershape:new({name='octa',
	shape1 = superformula:new({m=4, n1=1, n2=1, n3=1, a=1, b=1}),
	shape2 = superformula:new({m=4, n1=1, n2=1, n3=1, a=1, b=1}),
	phisteps = 4,
	thetasteps = 4})

-- Sphere
osphere = shape_supershape:new({name='octa',
	shape1 = superformula:new({m=0, n1=1, n2=1, n3=1, a=1, b=1}),
	shape2 = superformula:new({m=0, n1=1, n2=1, n3=1, a=1, b=1}),
	phisteps = 4,
	thetasteps = 4})

-- Cylinder
ocylinder = shape_supershape:new({name='cylinder',
	shape1 = superformula:new({m=1, n1=37.41, n2=-0.24, n3=19.07, a=1, b=1}),
	shape2 = superformula:new({m=4, n1=100, n2=100, n3=100, a=1, b=1}),
	phisteps = 4,
	thetasteps = 4})



--scene:clear()
--sphere(3)
--cone(1, 1, 4)

color({0.55, 0.55, 0.2, 1})
cone(2, 1.5, 6);
color({0.75, 0.75, 0, 0.75})
sphere(2);