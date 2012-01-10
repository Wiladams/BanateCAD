function setup()
	size(600, 400);
	background(128, 128, 128);
	noFill();
	stroke(255, 0, 0);
end

function draw()
	if (frameCount > 75) then return end

	local percent = map(frameCount, 0, 75, 0, 1);
	local v = percent;
	local centerx = lerp(100, 500, v);
	local centery = lerp(200, 100, sin(v*radians(180)));
	stroke(255, 255*v, 255*v);
	ellipse(centerx, centery, 75, 75);
end
