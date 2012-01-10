function setup()
	size(600, 400);
	background(210, 177, 68);
end

function draw()
	stroke(255, 0, 0);
	noFill();

	drawCircleTo(200, 150);
	drawCircleTo(200, 250);
	drawCircleTo(400, 250);
	drawCircleTo(400, 150);

	-- Yellow Box
	fill(255, 255, 0, 128);
	stroke(0);
	rect(200, 150, 200, 100);

	-- Rotate
	translate(300, 200);
	rotate(radians(10));

	-- Red Box
	fill(64, 64, 255, 128);
	rect(200, 150, 200, 100);
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