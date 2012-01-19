function setup()
	size(1024, 768);
	background(210, 177, 68);

	-- Move the origin to the center of the screen
	translate(width/2, height/2);

	stroke(0);
	noFill();

	strokeWeight(2);
	drawCircleTo(125, 75);
	--drawCircleTo(-125, -75);

	fill(149, 93, 13, 128);
	rect(-125, -75, 250, 150);
end

function draw()
	--pushMatrix();

	-- Rotate
	rotate(radians(4));

	fill(139, 49, 30, 128);
	rect(-125, -75, 250, 150);

	--popMatrix()
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