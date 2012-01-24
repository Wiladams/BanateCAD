--=====================================
-- This is public Domain Code
-- Contributed by: William A Adams
-- September 2011
--
-- Implement a language skin that makes
-- gives a GLSL feel to the coding
--=====================================
require ("LinearAlgebra")

pi = math.pi;





--=====================================
--	Angle and Trigonometry Functions (5.1)
--=====================================
function radians(degrees)
	if type(degrees) == 'number' then
		return  math.rad(degrees)
	end

	local res={}
	for i=1,#degrees do
		table.insert(res, math.rad(degrees[i]))
	end

	return res
end

function degrees(radians)
	if type(radians) == 'number' then
		return  math.deg(radians)
	end

	local res={}
	for i=1,#radians do
		table.insert(res, math.deg(radians[i]))
	end

	return res
end

function sin(radians)
	if type(radians) == 'number' then
		return  math.sin(radians)
	end

	local res={}
	for i=1,#radians do
		table.insert(res, math.sin(radians[i]))
	end

	return res
end

function cos(radians)
	if type(radians) == 'number' then
		return  math.cos(radians)
	end

	local res={}
	for i=1,#radians do
		table.insert(res, math.cos(radians[i]))
	end

	return res
end

function asin(radians)
	if type(radians) == 'number' then
		return  math.asin(radians)
	end

	local res={}
	for i=1,#radians do
		table.insert(res, math.asin(radians[i]))
	end

	return res
end

function acos(radians)
	if type(radians) == 'number' then
		return  math.acos(radians)
	end

	local res={}
	for i=1,#radians do
		table.insert(res, math.acos(radians[i]))
	end

	return res
end

function atan(radians)
	if type(radians) == 'number' then
		return  math.atan(radians)
	end

	local res={}
	for i=1,#radians do
		table.insert(res, math.atan(radians[i]))
	end

	return res
end

function sinh(radians)
	if type(radians) == 'number' then
		return  math.sinh(radians)
	end

	local res={}
	for i=1,#radians do
		table.insert(res, math.sinh(radians[i]))
	end

	return res
end

function cosh(radians)
	if type(radians) == 'number' then
		return  math.cosh(radians)
	end

	local res={}
	for i=1,#radians do
		table.insert(res, math.cosh(radians[i]))
	end

	return res
end


function tanh(radians)
	if type(radians) == 'number' then
		return  math.tanh(radians)
	end

	local res={}
	for i=1,#radians do
		table.insert(res, math.tanh(radians[i]))
	end

	return res
end


function asinh(radians)
	if type(radians) == 'number' then
		return  math.asinh(radians)
	end

	local res={}
	for i=1,#radians do
		table.insert(res, math.asinh(radians[i]))
	end

	return res
end

function acosh(radians)
	if type(radians) == 'number' then
		return  math.acosh(radians)
	end

	local res={}
	for i=1,#radians do
		table.insert(res, math.acosh(radians[i]))
	end

	return res
end

function atanh(radians)
	if type(radians) == 'number' then
		return  math.atanh(radians)
	end

	local res={}
	for i=1,#radians do
		table.insert(res, math.atanh(radians[i]))
	end

	return res
end

--=====================================
--	Common Functions (5.3)
--=====================================
function abs(x)
	if type(x) == 'number' then
		return  math.abs(x)
	end

	local res={}
	for i=1,#x do
		table.insert(res, math.abs(x[i]))
	end

	return res
end

function signfunc(x)
	if x > 0 then
		return 1
	elseif x < 0 then
		return -1
	end

	return 0
end

function sign(x)
	if type(x) == 'number' then
		return signfunc(x)
	end

	local res={}
	for i=1,#x do
		table.insert(res, signfunc(x[i]))
	end

	return res
end

function floor(x)
	if type(x) == 'number' then
		return  math.floor(x)
	end

	local res={}
	for i=1,#x do
		table.insert(res, math.floor(x[i]))
	end

	return res
end

function trucfunc(x)
	local asign = sign(x)
	local res = asign * math.floor(math.abs(x))

	return res
end

function trunc(x)
	if type(x) == 'number' then
		return  truncfunc(x)
	end

	local res={}
	for i=1,#x do
		table.insert(res, truncfunc(x[i]))
	end

	return res
end

function roundfunc(x)
	local asign = sign(x)
	local res = asign*math.floor((math.abs(x) + 0.5))

	return res
end

function round(x)
	if type(x) == 'number' then
		return  roundfunc(x)
	end

	local res={}
	for i=1,#x do
		table.insert(res, roundfunc(x[i]))
	end

	return res
end


function ceil(x)
	if type(x) == 'number' then
		return  math.ceil(x)
	end

	local res={}
	for i=1,#x do
		table.insert(res, math.ceil(x[i]))
	end

	return res
end

function fractfunc(x)
	return x - math.floor(x)
end

function fract(x)
	if type(x) == 'number' then
		local f = fractfunc(x)
		return f
	end

	local res={}
	for i=1,#x do
		table.insert(res, fractfunc(x[i]))
	end

	return res
end

function modfunc(x,y)
	return x - y * math.floor(x/y)
end

function mod(x,y)
	if type(x) == 'number' then
		local f = modfunc(x, y)
		return f
	end

	local res={}
	for i=1,#x do
		table.insert(res, modfunc(x[i], y[i]))
	end

	return res
end

function min(x,y)
	if type(x) == 'number' then
		local f = math.min(x, y)
		return f
	end

	local res={}
	for i=1,#x do
		table.insert(res, math.min(x[i], y[i]))
	end

	return res
end

function max(x,y)
	if type(x) == 'number' then
		local f = math.max(x, y)
		return f
	end

	local res={}
	for i=1,#x do
		table.insert(res, math.max(x[i], y[i]))
	end

	return res
end


function clampfunc(x, minVal, maxVal)
	return math.min(math.max(x, minVal), maxVal)
end

function clamp(x, minVal, maxVal)
	if type(x) == 'number' then
		local f = clampfunc(x, minVal, maxVal)
		return f
	end

	local res={}
	for i=1,#x do
		table.insert(res, clampfunc(x[i], minVal[i], maxVal[i]))
	end

	return res
end


function mixfunc(x, y, a)
	return x*(1.0 - a) + y * a
end

function mix(x, y, a)
	if type(x) == 'number' then
		local f = mixfunc(x, y, a)
		return f
	end

	local res={}
	for i=1,#x do
		table.insert(res, mixfunc(x[i], y[i], a[i]))
	end

	return res
end


function stepfunc(edge, x)
	if (x < edge) then
		return 0;
	else
		return 1;
	end
end

function step(edge, x, a)
	if type(x) == 'number' then
		local f = stepfunc(x, y, a)
		return f
	end

	local res={}
	for i=1,#x do
		table.insert(res, stepfunc(edge[i], x[i], a))
	end

	return res
end

-- Hermite smoothing between two points
function hermfunc(edge0, edge1, x)
	local range = (edge1 - edge0);
	local distance = (x - edge0);
	local t = clamp((distance / range), 0.0, 1.0);
	local r = t*t*(3.0-2.0*t);

	return r;
end

function smoothstepfunc(edge0, edge1, x)
	if (x <= edge0) then
		return 0.0
	end

	if (x >= edge1) then
		return 1.0
	end

	return	herm(edge0, edge1, x);
end



function smoothstep(edge0, edge1, x)
	if type(x) == 'number' then
		local f = smoothstepfunc(edge0, edge1, x)
		return f
	end

	local res={}
	for i=1,#x do
		table.insert(res, smoothstepfunc(edge0[i], edge1[i], x))
	end

	return res
end

function isnan(x)
	if x == nil then
		return true
	end

	if x >= math.huge then
		return true
	end

	local res={}
	for i=1,#x do
		table.insert(res, x >= math.huge)
	end

	return res
end

function isinf(x)
	if type(x) == 'number' then
		local f = x >= math.huge
		return f
	end

	local res={}
	for i=1,#x do
		table.insert(res, x >= math.huge)
	end

	return res
end


--=====================================
--	Geometric Functions (5.4)
--=====================================
function lengthfunc(x)
	local sum = 0
	for i=1,#x do
		sum = sum + (x[i]*x[i])
	end

	local f = sqrt(sum)
	return f
end

function length(x)
	if type(x) == 'number' then
		return x
	end

	local res= lengthfunc(x)

	return res
end


function distance(p0, p1)
	if type(p0) == 'number' then
		local f = p0-p1
		return f
	end

	local res = lengthfunc(p0-p1)

	return res
end


function dot(v1,v2)
	if type(p0) == 'number' then
		local f = v1*v2
		return f
	end

	local sum=0
	for i=1,#v1 do
		sum = sum + (v1[i]*v2[i])
	end

	return sum;
end

function cross(v1, v2)
	if #v1 ~= 3 then
		return {0,0,0}
	end

	return {
		(v1[2]*v2[3])-(v2[2]*v1[3]),
		(v1[3]*v2[1])-(v2[3]*v1[1]),
		(v1[1]*v2[2])-(v2[1]*v1[2])
	}
end

function normalize(x)
	if type(x) == 'number' then
		local f = x
		return f
	end
end


--=====================================
--	Vector Relational (5.4)
--=====================================
function isnumtrue(x)
	return x ~= nil and x ~= 0
end

function any(x)
	for i=1,#x do
		local f = isnumtrue(x[i])
		if f then return true end
	end

	return false
end

function all(x)
	for i=1,#x do
		local f = isnumtrue(x[i])
		if not f then return false end
	end

	return true
end


--=====================================
--	Vector Constructors
--=====================================
function vec2(x, y)
	return vec.new({x, y})
end

function vec3(x, y, z)
	return vec.new({x, y, z})
end

function vec4(x,y,z,w)
	return vec.new({x, y, z, w})
end

---[[
v1 = vec.new{1, 0, 1, 0}
v2 = vec3(1, 1, 1)
v3 = vec3(0, 0, 0)

print(any(v1))
print(any(v3))

print(all(v1))
print(all(v2))

--]]
