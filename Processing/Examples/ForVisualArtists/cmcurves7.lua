
local xp = {100, 300, 300, 100}
local yp = {100, 100, 300, 300}


function setup()
	size(600, 400);
	background(242, 240, 174);
	noFill();
end

function drawCurve(drawCircles, drawLines, p1, p2, p3, p4)
	-- control point 1
	stroke(255, 0, 0);
	if drawCircles then
		ellipse(xp[p1], yp[p1], 15, 15);
	end
	if drawLines then
		line(xp[p1], yp[p1], xp[p2], yp[p2]);
	end

	-- control point 2
	stroke(0, 0, 255);
	if drawCircles then
		ellipse(xp[p4], yp[p4], 15, 15);
	end
	if drawLines then
		line(xp[p4], yp[p4], xp[p3], yp[p3]);
	end

	-- Draw the knots
	stroke(0)
	if drawCircles then
		ellipse(xp[p2], yp[p2], 15, 15);
		ellipse(xp[p3], yp[p3], 15, 15);
	end

	-- draw curves here
	curve(xp[p1], yp[p1],  xp[p2],yp[p2],  xp[p3],yp[p3],  xp[p4],yp[p4]);
end

function draw()
	drawCurve(true, false, 1,2,3,4)
	drawCurve(false, false, 2,3,4,1)
end
