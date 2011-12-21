
Color = {}

function color(...)
	-- There can be 1, 2, 3, or 4, arguments
--	print("Color.new - ", arg.n)

	local acolor = {0.5, 0.5, 0.5, 1}	-- default to a gray

	if Processing.ColorMode == RGB then
		if (arg.n == 1) then
			acolor[1] = arg[1]/255
			acolor[2] = arg[1]/255
			acolor[3] = arg[1]/255
			acolor[4] = 1
		elseif arg.n == 2 then
			acolor[1] = arg[1]/255
			acolor[2] = arg[1]/255
			acolor[3] = arg[1]/255
			acolor[4] = arg[2]/255
		elseif arg.n == 3 then
			acolor[1] = arg[1]/255
			acolor[2] = arg[2]/255
			acolor[3] = arg[3]/255
			acolor[4] = 1
		elseif arg.n == 4 then
			acolor[1] = arg[1]/255
			acolor[2] = arg[2]/255
			acolor[3] = arg[3]/255
			acolor[4] = arg[4]/255
		end
	end

	return acolor
end

function background(...)
	local acolor = color(unpack(arg))
--print("background: ", acolor[1], acolor[2], acolor[3], acolor[4])
	return Processing.SetBackgroundColor(acolor)
end

function colorMode(amode)
	-- if it's not valid input, just return
	if amode ~= RGB and amode ~= HSB then return end

	return Processing.SetColorMode(amode)
end

function fill(...)
	local acolor = color(unpack(arg))

	return Processing.SetFillColor(acolor)
end

function noFill()
	local acolor = color(0,0,0,0)

	return Processing.SetFillColor(acolor)
end

function noStroke(...)
	local acolor = color(0,0,0,0)

	return Processing.SetStrokeColor(acolor)
end

function stroke(...)
--[[
	if arg.n == 1 and type(arg[1]) == "table" then
		-- We already have a color structure
		-- so just set it
		return Processing.SetStrokeColor(acolor)
	end
--]]
	-- Otherwise, construct a new color object
	-- and set it
	local acolor = color(unpack(arg))

	return Processing.SetStrokeColor(acolor)
end

--[[
require("Language")

print("Color.lua - TEST")

local c1 = color(10, 20, 30)

print(c1[1], c1[2], c1[3], c1[4])

background(102,200,30)
--]]
