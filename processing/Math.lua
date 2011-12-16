--
-- Math
--
-- class PVector

-- Calculation

function abs()
end

function ceil()
end

function constrain()
end

function dist()
end

function exp()
end

function floor()
end

function lerp()
end

function log()
end

function mag()
end

function map()
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

function norm()
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

function acos()
end

function asin()
end

function atan()
end

function atan2()
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
	if arg.n == 1 then
		return math.random(0, arg[1])
	elseif arg.n == 2 then
		return math.random(arg[1], arg[2])
	end
end

function randomSeed(...)
end



--[[
print("Math.lua - TESTING")
print("min()")
local d = min(5,9)
local e = min(-4, -12)
local f = min(12.3, 230.24, 5)

print(d,e,f)

local list = {5,1,2,-3}
local h = min(list)
print(h)

print("max()")
d = max(5,9)
e = max(-4, -12)
f = max(12.3, 230.24, 5)

print(d,e,f)

list = {5,1,2,-3}
h = max(list)
print(h)

--]]
