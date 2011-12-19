function setup()
	size(600, 250)
	background(200)
end

function draw()
	background(200)
	fill(47, 64, 84);
	rect(25, 25, 550, 140);

	fill(249, 246, 155);

	local numEllipse = 5
	local offset = 110
	for i=1, numEllipse do
		ellipse(80 + ((i-1)*offset), 95, 80, 80);
	end
end