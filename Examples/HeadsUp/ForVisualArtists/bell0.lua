function setup()
	size(600, 400);
	background(128, 128, 128);
	noFill();
	stroke(255, 0, 0);
end

function draw()
	if (frameCount > 75) then return end

	local centerx = map(frameCount, 0, 75, 100, 500);
	ellipse(centerx, 200, 75,75);
end
