-- constants
local Y_AXIS = 1;
local X_AXIS = 2;

function setup()
	size(400, 400);

	-- create some gradients
	-- background
	local b1 = color(190, 190, 190);
	local b2 = color(20, 20, 20);
	setGradient(0,0,width, height, b1, b2, X_AXIS);

	-- center squares
	local c1 = color(255, 120, 0);
	local c2 = color(10, 45, 255);
	local c3 = color(10, 255, 15);
	local c4 = color(125, 2, 140);
	local c5 = color(255, 255, 0);
	local c6 = color(25, 255, 200);
	setGradient(50, 50, 150, 150, c1, c2, Y_AXIS);
	setGradient(200, 50, 150, 150, c3, c4, X_AXIS);
	setGradient(50, 200, 150, 150, c2, c5, X_AXIS);
	setGradient(200, 200, 150, 150, c4, c6, Y_AXIS);
end

function setGradient(x, y, w, h, c1, c2, axis)
	-- calculate differences between color components
	local deltaR = c2.R - c1.R
	local deltaG = c2.G - c1.G
	local deltaB = c2.B - c1.B

	-- choose axis
	if axis == Y_AXIS then
		-- column
		for i=x,x+w do
			-- row
			for j=y, y+h do
				local c = color(
					c1.R+(j-y)*(deltaR/h),
					c1.G+(j-y)*(deltaG/h),
					c1.B+(j-y)*(deltaB/h))
				set(i,j,c)
			end
		end
	elseif axis == X_AXIS then
		-- column
		for i=y, y+h do
			-- row
			for j=x, x+w do
				local c = color(
					c1.R+(j-x)*(deltaR/h),
					c1.G+(j-x)*(deltaG/h),
					c1.B+(j-x)*(deltaB/h))
				set(j,i,c)
			end
		end
	end
end

