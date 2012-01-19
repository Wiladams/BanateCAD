function setup()
	Processing.Renderer:ResetTransform()
	size(640, 480);
--end

--function draw()
	background(210, 177, 68);

	stroke(0)
	noFill();
	strokeWeight(2);
	local radiusUL = dist(0, 0, 150, 100);
	ellipse(0, 0, radiusUL*2, radiusUL*2);

	fill(149, 93, 13, 128);
	rect(150, 100, 250, 150);

	fill(139, 49, 30,128);
	rotate(radians(20));
	rect(150, 100, 250, 150);
end