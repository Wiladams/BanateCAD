-- maths.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
-- Useful constants
Cphi = 1.61803399;
Cpi = 3.14159
Ctau = Cpi*2
Cepsilon = 0.00000001;

Cdegtorad = 2*Cpi/360;


-- Degrees minutes seconds
function dmstodeg(degrees, minutes, seconds)
	degrees = degrees or 0
	minutes = minutes or 0
	seconds = seconds or 0
	return degrees + (minutes/60) + (seconds / (60*60))
end

-- latitude longitude to spherical
function latlonto_sph(latitude, longitude)
	local latsign = sign(latitude)
	local lonsign = sign(longitude)

	local newlat = latsign*90 - latitude
	local newlon = 180 - longitude

	return newlat, newlon
end

require "Vector"
require "mat4"
require "tform"
require "cubiccurves"
require "spherical"

--=======================================
--
--	Linear Interpolation Routines
--
--=======================================
function lerpfunc( p0, p1, u)
	return p0 + (p1-p0)*u
end

---[[
function lerp(p0, p1, u)
	if type(p0) == 'number' then
		return  lerpfunc(p0, p1, u)
	end

	local res={}
	for i=1,#p0 do
		table.insert(res, lerpfunc(p0[i], p1[i], u))
	end

	return res
end
--]]

function map(a, rlo, rhi, slo, shi)
	return slo + ((a-rlo)/(rhi-rlo) * (shi-slo))
end

function constrain(value, amin, amax)
	if value < amin then return amin end
	if value > amax then return amax end

	return value
end

function norm(val, in1, in2)
	local part = val - in1
	local range = in2-in1
	local frac = part / range

	return frac
end


function sq(value)
	return value*value
end

function sqrt(value)
	return math.sqrt(value)
end

function mag(x1, y1)
	return math.sqrt(x1*x1+y1*y1)
end

function dist(x1, y1, x2, y2)
	local dx = x2-x1
	local dy = y2-y1

	local d = sqrt(dx*dx + dy*dy)

	return d
end


function pow(num, exponent)
	return math.pow(num, exponent)
end


-- Useful functions
function factorial(n)
	if n==0 then
		return 1
	else
		return n * factorial(n-1)
	end
end

--[[
 Function: clean

 Parameters:
	n - A number that might be very close to zero
 Description:
	There are times when you want a very small number to
 	just be zero, instead of being that very small number.
	This function will compare the number to an arbitrarily small
	number.  If it is smaller than the 'epsilon', then zero will be
 	returned.  Otherwise, the original number will be returned.
--]]

function clean(n)
	if (n < 0) then
		if (n < -Cepsilon) then
			return n
		else
			return 0
		end
	else if (n < Cepsilon) then
			return 0
		else
			return n
		end
	end
end

--[[
 Function: safediv

 Parameters
	n - The numerator
	d - The denominator

 Description:
	Since division by zero is generally not a desirable thing, safediv
	will return '0' whenever there is a division by zero.  Although this will
	mask some erroneous division by zero errors, it is often the case
	that you actually want this behavior.  So, it makes it convenient.
--]]
function safediv(n,d)
	if (d==0) then
		return 0
	end

	return n/d;
end


-- Calculate the centroid of a list of vertices

function centroid(verts)
	local minx = math.huge; maxx = -math.huge
	local miny = math.huge; maxy = -math.huge
	local minz = math.huge; maxz = -math.huge

	for _,v in ipairs(verts) do
		minx = math.min(v[1], minx); maxx = math.max(v[1], maxx);
		miny = math.min(v[2], miny); maxy = math.max(v[2], maxy);
		minz = math.min(v[3], minz); maxz = math.max(v[3], maxz);
	end

	local x = minx + (maxx-minx)/2;
	local y = miny + (maxy-miny)/2;
	local z = minz + (maxz-minz)/2;

	return vec3(x,y,z)
end

function normalizeAngle(angle)
	while angle < 0 do
		angle = angle + 360;
	end

	while angle > 360 do
		angle = angle - 360;
	end

	return angle;
end

-- Random
function noise(...)
end

function noiseDetail(...)
end

function noiseSeed(...)
end

function random(...)
	local num = math.random()

	if arg.n == 1 then
		if arg[1] == 0 then return 0 end
		return num * arg[1]
	elseif arg.n == 2 then
		local range = arg[2] - arg[1]

		return arg[1] + (range * num)
	end

	return 0
end

function randomSeed(aseed)
	math.randomseed(aseed)
end

-- Processing
function exp()
end


function log()
end

--[[
print("maths.lua - TEST")

function print_mat4(m4)
	for i=1,4 do
		print(m4[i][1]..','..m4[i][2]..','..m4[i][3]..','..m4[i][4]);
	end
end

function test_mat4()
	local idmat4 = mat4_identity()
	local trans1 = transform_translate({2, 2, 2})
	local trans2 = mat4_transpose(trans1)

	print_mat4(trans1);
	print();
	print_mat4(trans2);
end

function showmap(a, rlo, rhi, slo, shi)
	print("map "..a.." from("..rlo..", "..rhi..") to ("..slo..", "..shi..") = "..map(a, rlo, rhi, slo, shi))
end

function testmap()
	local r1 = 10
	local r2 = 20
	local s1 = 30
	local s2 = 40
	local a = 12

	showmap(a, r1, r2, s1, s2)
	showmap(a, r2, r1, s1, s2)
	showmap(a, r1, r2, s2, s1)
	showmap(a, r2, r1, s2, s1)

	showmap(127, 0,255, 0, 1)
end

test_mat4();

--]]
