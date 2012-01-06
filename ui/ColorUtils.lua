require "Color"

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

return ColorUtils
