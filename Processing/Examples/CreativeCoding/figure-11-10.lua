local x
local y
local easing = 0.05

function setup()
	size(400, 400)
	x = width / 2;
	y = height / 2;
	smooth();
end

function draw()
	-- repaint background
	fill(255, 40);
	rect(0,0,width, height);

	-- find distance for x and y
	-- between prey and predator
	local deltaX = (pmouseX - x);
	local deltaY = (pmouseY - y);

	-- cause the predator to decelerate
	deltaX = deltaX*easing;
	deltaY = deltaY*easing;

	x = x + deltaX;
	y = y + deltaY;
	fill(53)
	rect(x, y, 15, 15)
end

