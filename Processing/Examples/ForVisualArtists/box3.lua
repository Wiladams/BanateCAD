function setup()
	size(600, 400);
end

function draw()
	background(210, 177, 68);

	fill(149, 93, 13, 128);
	rect(150, 100, 250, 150);

	fill(139, 49, 30,128);
	rotate(radians(20));
	rect(150, 100, 250, 150);
end