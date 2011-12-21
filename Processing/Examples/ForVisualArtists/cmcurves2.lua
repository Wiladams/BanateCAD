
local xp = {100, 300, 300, 100}
local yp = {100, 100, 300, 300}

function setup()
	size(600, 400);
	background(242, 240, 174);
	noFill();
end

function draw()
	for i=1,#xp do
		ellipse(xp[i], yp[i], 15, 15);
	end

	-- draw curves here
end