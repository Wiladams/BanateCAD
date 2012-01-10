function setup()
	size(600, 250)
	background(200)
end

function draw()
	fill(47, 64, 84);
	rect(25, 25, 550, 140);

	fill(249, 246, 155);

	local numEllipse = 10
	local offset = 110
	local sizeX = 40
	local sizeY = 40
	for i=0, numEllipse-1 do
		local myAlpha = map(i, 0, numEllipse-1, 0, 255)
		fill(255, 255, 0, myAlpha)
		local xValue = 60 + (i*50)
		ellipse(xValue, 165, 40, 40);
	end
end