funangle = math.rad(137.5)
radius = 30
anglesteps = 360*3
lathigh = math.pi * .75
latlow = math.pi - lathigh
latrange = lathigh-latlow
tetrasize = 1

for i=0,anglesteps do
	v = i/anglesteps
	local long = i*funangle;
	local lat = latlow + v*latrange;
	local pos = sph_to_cart({long, lat, radius})

	color({1-v,lat/math.pi,v,1})
	translate(pos)
	tetrahedron(tetrasize)
end