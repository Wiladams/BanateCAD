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




function apply(f, v)
	if type(v) == "number" then
		return f(v)
	end
	if type(v) == "table" then
		local res = {}
		for i=1,#v do
			res[i] = f(v[i])
		end
		return res
	end

	return nil
end

function apply2(f, v1, v2)
	if type(v1) == "number" then
		return f(v1, v2)
	end
	if type(v1) == "table" then
		local res = {}
		if type(v2)=="number" then
            for i=1,#v1 do
				res[i] = f(v1[i],v2)
			end
		else
			for i=1,#v1 do
				res[i] = f(v1[i], v2[i])
			end
		end
		return res
	end
	return nil
end

function add(x,y)
	return apply2(function(x,y) return x + y end,x,y)
end

function sub(x,y)
	return apply2(function(x,y) return x - y end,x,y)
end

function mul(x,y)
	if type(x)=="number" then -- swap params, just in case y is a vector
		return apply2(function(x,y) return x * y end,y,x)
	else
 		return apply2(function(x,y) return x * y end,x,y)
	end
end

function div(x,y)
	return apply2(function(x,y) return x / y end,x,y)
end

-- improved equality test with tolerance
function equal(v1,v2,tol)
	assert(type(v1)==type(v2),"equal("..type(v1)..","..type(v2)..") : incompatible types")
	if not tol then tol=1E-12 end
	return apply(function(x) return x<=tol end,abs(sub(v1,v2)))
end

function notEqual(v1,v2,tol)
	assert(type(v1)==type(v2),"equal("..type(v1)..","..type(v2)..") : incompatible types")
	if not tol then tol=1E-12 end
	return apply(function(x) return x>tol end,abs(sub(v1,v2)))
end

--=====================================
--	Angle and Trigonometry Functions (5.1)
--=====================================

function radians(degs)
	return apply(math.rad, degs)
end

function degrees(rads)
	return apply(math.deg, rads)
end

function sin(rads)
	return apply(math.sin, rads)
end

function cos(rads)
	return apply(math.cos, rads)
end

function tan(rads)
	return apply(math.tan, rads)
end

function asin(rads)
	return apply(math.asin, rads)
end

function acos(rads)
	return apply(math.acos, rads)

end



function atan(rads)
	return apply(math.atan, rads)
end

function atan2(y,x)
	return apply2(math.atan2,y,x)
end

function sinh(rads)
	return apply(math.sinh, rads)
end

function cosh(rads)
	return apply(math.cosh, rads)
end


function tanh(rads)
	return apply(math.tanh, rads)
end

--[[
function asinh(rads)
	return apply(math.asinh, rads)
end

function acosh(rads)
	return apply(math.acosh, rads)
end

function atanh(rads)
	return apply(math.atanh, rads)
end
--]]

--=====================================
--	Exponential Functions (5.2)
--=====================================
function pow(x,y)
	return apply2(math.pow,x,y)
end

function exp2(x)
	return apply2(math.pow,2,x)
end

function log2(x)
	return apply(math.log,x)/math.log(2)
end

function sqrt(x)
	return apply(math.sqrt,x)
end

local function inv(x)
	return apply(function(x) return 1/x end,x)
end

function invsqrt(x)
	return inv(sqrt(x))
end

--=====================================
--	Common Functions (5.3)
--=====================================
function abs(x)
	return apply(math.abs, x)
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
	return apply(signfunc, x)
end

function floor(x)
	return apply(math.floor, x)
end

function trucfunc(x)
	local asign = sign(x)
	local res = asign * math.floor(math.abs(x))

	return res
end

function trunc(x)
	return apply(truncfunc, x)
end

function roundfunc(x)
	local asign = sign(x)
	local res = asign*math.floor((math.abs(x) + 0.5))

	return res
end

function round(x)
	return apply(roundfunc, x)
end


function ceil(x)
	return apply(math.ceil, x)
end

function fractfunc(x)
	return x - math.floor(x)
end

function fract(x)
	return apply(fractfunc, x)
end

function modfunc(x,y)
	return x - y * math.floor(x/y)
end

function mod(x,y)
	return apply2(modfunc, x, y)
end

function min2(x,y)
	return apply2(math.min, x, y)
end

function min(...)
	if arg.n == 2 then
		return min2(arg[1], arg[2])
	elseif arg.n == 3 then
		return math.min(math.min(arg[1], arg[2]), arg[3])
	end

	if type(arg[1]) == "table" then
		local lowest = math.huge
		for i=1,#arg[1] do
			lowest = math.min(lowest, arg[1][i])
		end

		return lowest
	end

	-- If we got to here, then it was invalid input
	return nil
end

function max2(x,y)
	return apply2(math.max, x, y)
end


function max(...)
	if arg.n == 2 then
		return max2(arg[1], arg[2])
	elseif arg.n == 3 then
		return math.max(math.max(arg[1], arg[2]), arg[3])
	end

	if type(arg[1]) == "table" then
		local highest = -math.huge
		for i=1,#arg[1] do
			highest = math.max(highest, arg[1][i])
		end

		return highest
	end

	-- If we got to here, then it was invalid input
	return nil
end





function clamp(x, minVal, maxVal)
	return min(max(x,minVal),maxVal)
end


function mixfunc(x, y, a)
	return x*(1.0 - a) + y * a
end

-- x*(1.0 - a) + y * a
-- same as...
-- x + s(y-x)
-- Essentially lerp
function mix(x, y, a)
	return add(x,mul(sub(y,x),a))
end


function stepfunc(edge, x)
	if (x < edge) then
		return 0;
	else
		return 1;
	end
end

function step(edge, x)
	return apply2(stepfunc, edge, x)
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
function dot(v1,v2)
	if type(v1) == 'number' then
		return v1*v2
	end

	if (type(v1) == 'table') then
		-- if v1 is a table
		-- it could be vector.vector
		-- or matrix.vector
		if type(v1[1] == "number") then
			local sum=0
			for i=1,#v1 do
				sum = sum + (v1[i]*v2[i])
			end
			return sum;
		else -- matrix.vector
			local res={}
			for i,x in ipairs(v1) do
				res[i] = dot(x,v2) end
			return res
		end
	end
end

function length(v)
	return math.sqrt(dot(v,v))
end

function distance(v1,v2)
	return length(sub(v1,v2))
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

function normalize(v1)
	return div(v1,length(v1))
end

function faceforward(n,i,nref)
	if dot(n,i)<0 then return n else return -n end
end

function reflect(i,n)
	return sub(i,mul(mul(2,dot(n,i)),n))
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

-- angle (in radians) between u and v vectors
function angle(u, v)
	if dot(u, v) < 0 then
		return math.pi - 2*asin(length(add(u,v))/2)
	else
		return 2*asin(distance(v,u)/2)
	end
end

--=====================================
--	Vector Constructors
--=====================================
function vec2(x, y)
	return vec.new({x, y})
end

function vec3(x, y, z)
	z = z or 0
	return vec.new({x, y, z})
end

function vec4(x,y,z,w)
	w = w or 0
	return vec.new({x, y, z, w})
end

--[[
print("glsl.lua - TEST")

for angle = 0,math.pi, math.pi/8  do
	print(sin(angle))
end

v1 = vec.new{1, 0, 1, 0}
v2 = vec3(1, 1, 1)
v3 = vec3(0, 0, 0)

print(any(v1))
print(any(v3))

print(all(v1))
print(all(v2))

--]]
