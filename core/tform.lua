-- Linear Transformations
--	Translate
function transform_translate(xyz)
	return {
	{1, 0, 0, 0},
	{0, 1, 0, 0},
	{0, 0, 1, 0},
	{xyz[1], xyz[2], xyz[3], 1}
	}
end

-- 	Scale
function  transform_scale(xyz)
	return {
	{xyz[1],0,0,0},
	{0,xyz[2],0,0},
	{0,0,xyz[3],0},
	{0,0,0,1}
	}
end

--	Rotation
function transform_rotx(deg)
	local rad = Cdegtorad * deg;
	local sinang = math.sin(rad);
	local cosang = math.cos(rad);

	return {
	{1, 0, 0, 0},
	{0, cosang, sinang, 0},
	{0, -sinang, cosang, 0},
	{0, 0, 0, 1}
	}
end

function  transform_rotz(deg)
	local rad = Cdegtorad * deg;
	local sinang = math.sin(rad);
	local cosang = math.cos(rad);

	return {
	{cosang, sinang, 0, 0},
	{-sinang, cosang, 0, 0},
	{0, 0, 1, 0},
	{0, 0, 0, 1}
	}
end

function  transform_roty(deg)
	local rad = Cdegtorad * deg;
	local sinang = math.sin(rad);
	local cosang = math.cos(rad);

	return {
	{cosang, 0, -sinang, 0},
	{0, 1, 0, 0},
	{sinang, 0, cosang, 0},
	{0, 0, 0, 1}
	}
end
