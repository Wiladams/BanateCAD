--
-- Math
--
-- class PVector

-- Calculation

function abs(value)
	return math.abs(value)
end

function ceil(value)
	return math.ceil(value)
end

function constrain(value, amin, amax)
	if value < amin then return amin end
	if value > amax then return amax end

	return value
end

function dist(x1, y1, x2, y2)
	local dx = x2-x1
	local dy = y2-y1

	local d = sqrt(dx*dx + dy*dy)

	return d
end

function exp()
end

function floor(value)
	return math.floor(value)
end

--function lerp()
--end

function log()
end

function mag(x1, y1)
	return sqrt(x1*x1+y1*y1)
end

function map(a, rlo, rhi, slo, shi)
	return slo + ((a-rlo)/(rhi-rlo) * (shi-slo))
end

function max(...)
	if arg.n == 2 then
		return math.max(arg[1], arg[2])
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

function min(...)
	if arg.n == 2 then
		return math.min(arg[1], arg[2])
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

function norm(val, in1, in2)
	local part = val - in1
	local range = in2-in1
	local frac = part / range

	return frac
end

function pow(num, exponent)
	return math.pow(num, exponent)
end

-- Rounds away from zero
function round(value)
	local asign = sign(x)
	local res = asign*math.floor((math.abs(x) + 0.5))

	return res
end

function sq(value)
	return value*value
end

function sqrt(value)
	return math.sqrt(value)
end



-- Trigonometry

function acos(rad)
	return math.acos(rad)
end

function asin(rad)
	return math.asin(rad)
end

function atan(value)
	return math.atan(value)
end

function atan2(x, y)
	return math.atan(x/y)
end

function cos(rad)
	return math.cos(rad)
end

function degrees(rad)
	return math.deg(rad)
end

function radians(deg)
	return math.rad(deg)
end

function sin(rad)
	return math.sin(rad)
end

function tan(rad)
	return math.tan(rad)
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



--[[
print("Math.lua - TESTING")

print("dist")
local d = dist(0,0,150,100)
print(d)

print("norm")
print(norm(20, 0, 50))

--print("min()")
local d = min(5,9)
local e = min(-4, -12)
local f = min(12.3, 230.24, 5)

--print(d,e,f)

local list = {5,1,2,-3}
local h = min(list)
--print(h)

--print("max()")
d = max(5,9)
e = max(-4, -12)
f = max(12.3, 230.24, 5)

--print(d,e,f)

list = {5,1,2,-3}
h = max(list)
--print(h)

local rand = 0
local r = random(0,0)
print(r)

for i=1,100 do
	print(random(0.7, 0.98))
end
--]]
