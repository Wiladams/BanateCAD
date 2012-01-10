-- Simple Motion Physics II
local shapes = 1200
local w = {}
local h = {}
local lum = {}
local x = {}
local y = {}
local xSpeed = {}
local ySpeed = {}
local gravity = {}
local damping = {}
local friction = {}

-- controls rate rects are born
local shapeCount = 0;
local birthRate = 3

-- control width of spray when rects are born
local sprayWidth = 2;


function setup()
	size(400, 400);
	noStroke();

	-- initialize arrays with random values
	for i=1,shapes do

		w[i] = random(2,6)
		h[i] = w[i]
		x[i] = random(width-w[i])
		y[i] = 0
		lum[i] = random(127,255)
		xSpeed[i] = random(-sprayWidth, sprayWidth);
		ySpeed[i] = 0
		gravity[i] = 0.1
		damping[i] = random(0.2, 0.3)
		friction[i] = random(0.65, 0.95);
	end

end

function draw()
	fill(55, 100);
	rect(0,0, width, height);
	--fill(0);

	-- shapeCount births rects over time
	for i=1, shapeCount do
		fill(lum[i])
		rect(x[i], y[i],w[i], h[i]);

		x[i] = x[i] + xSpeed[i];
		ySpeed[i] = ySpeed[i] + gravity[i];
		y[i] = y[i] +ySpeed[i];

		-- Collision detection
		if y[i] >= height-h[i] then
			y[i] = height-h[i]
			-- bounce
			ySpeed[i] = - ySpeed[i]

			-- slow down vertical motion on ground collisions
			ySpeed[i] = ySpeed[i] * damping[i]

			-- slow down lateral motioin on ground collision
			xSpeed[i] = xSpeed[i] * friction[i];
		end
	
		if y[i] <=0 then
			y[i] = 0
			ySpeed[i] = -ySpeed[i]
		end

		if x[i] >= width - w[i] then
			x[i] = width - w[i];
			xSpeed[i] = -xSpeed[i]
		end

		if x[i] <= 0 then
			x[i] = 0;
			xSpeed[i] = -xSpeed[i]
		end

		-- put it back at the top
		if ySpeed[i] == 0 then
			y[i] = 0 
		end
	end

	if shapeCount < shapes then
		shapeCount = shapeCount + birthRate
		if shapeCount > shapes then
			shapeCount = shapes
		end
	end
end