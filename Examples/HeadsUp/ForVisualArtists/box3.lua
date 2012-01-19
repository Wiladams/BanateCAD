function setup()
	Processing.Renderer:ResetTransform()
	size(600, 400);
	background(210, 177, 68);
--end

--function draw()


	fill(149, 93, 13, 128);
	rect(150, 100, 250, 150);

	fill(139, 49, 30,128);
	rotate(radians(20));
	rect(150, 100, 250, 150);
end