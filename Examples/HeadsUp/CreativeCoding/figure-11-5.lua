-- Acceleration with Gravity
local speedX=0
local speedY=0
local x=0
local y=0
local w=0
local h=0

-- acceleration force
local gravity=0;

function setup()
	size(400, 400);
	x = width /2;
	w = 15;
	h = w;
	fill(0)
	speedX = 4;

	-- set acceleration force
	gravity = 0.5;
end

function draw()
	fill(255, 30);
	rect(0,0, width, height);

	fill(0);
	rect(x,y, w,h);
	x = x + speedX;
	speedY = speedY + gravity;
	y = y+speedY;

	-- check display window edge collisions
	if x > width -w then
		x = width - w;
		speedX = -speedX;
	elseif x < 0 then
		x = 0;
		speedX = -speedX
	elseif y > height-h then
		y = height -h;
		speedY = -speedY;
	elseif y < 0 then
		y = 0;
		speedY = speedY * -1
	end
end