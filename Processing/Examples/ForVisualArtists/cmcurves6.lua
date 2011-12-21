
local xp = {100, 300, 300, 100}
local yp = {100, 100, 300, 300}


function setup()
	size(600, 400);
	background(242, 240, 174);
	noFill();

	stroke(255, 0, 0);
	ellipse(xp[1], yp[1], 15, 15);
	line(xp[1], yp[1], xp[2], yp[2]);

	stroke(0, 0, 255);
	ellipse(xp[4], yp[4], 15, 15);
	line(xp[4], yp[4], xp[3], yp[3]);

	stroke(0)
	ellipse(xp[2], yp[2], 15, 15);
	ellipse(xp[3], yp[3], 15, 15);

	-- draw curves here
	curve(xp[1], yp[1],  xp[2],yp[2],  xp[3],yp[3],  xp[4],yp[4]);
end