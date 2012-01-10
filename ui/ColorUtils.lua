local bit = require "bit"

local band = bit.band
local lshift = bit.lshift
local rshift = bit.rshift
--local color = require "Color"

ColorUtils = {}

function ColorUtils.darker(acolor)
	local red = (acolor.R *0.60);
	local green = (acolor.G * 0.60);
	local blue = (acolor.B * 0.60);

	return Color(red, green, blue);
end

function ColorUtils.brighter(acolor)
	local red = (math.min(acolor.R *(1/0.80), 255));
	local green = (math.min(acolor.G * (1.0/0.85), 255));
	local blue = (math.min(acolor.B * (1.0/0.80), 255));

	return Color(red, green, blue);
end

function ColorUtils.cref(r,g,b,a)
	a = a or 255
	b = b or 0
	g = g or 0
	r = r or 0

	local value = lshift(a, 24) + lshift(r, 16) + lshift(g, 8) + b
	return value
end

function ColorUtils.rgba(c)
	local b = band(c, 0xff)
	c = rshift(c,8)
	local g = band(c, 0xff)
	c = rshift(c,8)
	local r = band(c, 0xff)
	c = rshift(c, 8)
	local a = band(c, 0xff)

	return r,g,b,a
end

function ColorUtils.rgbaNormalized(c)
	local r,g,b,a = rgba(c)

	return {r/255, g/255, b/255, a/255}
end


return ColorUtils
