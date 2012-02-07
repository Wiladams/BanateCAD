--[[
==================================
  Spherical coordinates
==================================
--]]

--[[
 create an instance of a spherical coordinate
 long - rotation around z -axis
 lat - latitude, starting at 0 == 'north pole'
 rad - distance from center
--]]
function sph(long, lat, rad)
	return {long, lat, rad}
end

-- Convert spherical to cartesian
function sph_to_cart(s)
	return vec3(
	clean(s[3]*math.sin(s[2])*math.cos(s[1])),
	clean(s[3]*math.sin(s[2])*math.sin(s[1])),
	clean(s[3]*math.cos(s[2]))
	)
end

-- Convert from cartesian to spherical
function sph_from_cart(c)
	return sph(
	math.atan2(c[2],c[1]),
	math.atan2(math.sqrt(c[1]*c[1]+c[2]*c[2]), c[3]),
	math.sqrt(c[1]*c[1]+c[2]*c[2]+c[3]*c[3])
	)
end

function sphu_from_cart(c, rad)
	return sph(
	math.atan2(c[2],c[1]),
	math.atan2(math.sqrt(c[1]*c[1]+c[2]*c[2]), c[3]),
	rad
	)
end

-- compute the chord distance between two points on a sphere
function sph_dist(c1, c2)
	return math.sqrt(
	c1[3]*c1[3] + c2[3]*c2[3] -
	2*c1[3]*c2[3]*
	((math.cos(c1[2])*math.cos(c2[2])) +
	math.cos(c1[1]-c2[1])*math.sin(c1[2])*math.sin(c2[2]))
	);
end
