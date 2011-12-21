function setup()
	size(600, 400);
	background(192, 192, 192);
end

function draw()
	stroke(255, 0, 0);
	noFill();

	drawCircleTo(200, 150);
	drawCircleTo(200, 250);
	drawCircleTo(400, 250);
	drawCircleTo(400, 150);

	fill(255, 255, 0, 128);
	stroke(0,0,0);
	rect(200, 150, 200, 100);	-- The yellow box

	rotate(radians(10));
	fill(64, 64, 255, 128);
	rect(200, 150, 200, 100);		-- The red box
end

function drawCircleTo(x, y)
	local r = dist(0,0,x,y);
	ellipse(0, 0, 2*r, 2*r);
end