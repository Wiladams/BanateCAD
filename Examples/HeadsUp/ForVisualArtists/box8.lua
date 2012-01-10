function setup()
	size(600, 400);
	background(210, 177, 68);
end

function draw()
	stroke(0);
	noFill();

	-- Move the origin to the center of the screen
	translate(300, 200);

	strokeWeight(2);
	drawCircleTo(125, 75);
	drawCircleTo(-125, -75);

	fill(149, 93, 13, 128);
	rect(-125, -75, 250, 150);

	-- Rotate
	rotate(radians(20));

	fill(139, 49, 30, 128);
	rect(-125, -75, 250, 150);
end

function drawCircleTo(x, y)
	local r = dist(0,0,x,y);
	ellipse(0, 0, 2*r, 2*r);
end

function drawBox(left, top, wid, hgt)
	rect(left, top, wid, hgt);

	-- draw perfectly vertical lines
	for x=0, wid-1, 20 do
		line(left+x, top-20, left+x, top+hgt+20);
	end

	-- draw perfectly horizontal lines
	for y=0, hgt-1, 20 do
		line(left-20, top+y, left+wid+20, top+y);
	end
end