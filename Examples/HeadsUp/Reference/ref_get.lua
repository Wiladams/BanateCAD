local img = loadImage("csg1.png")

function setup()
	background(55);

	img:loadPixels();
	drawLine();

	--displayImage();
	img:updatePixels();

	image(img,0,0)
end

function displayImage()
	for row=0,img.height-1 do
		for column=0,img.width-1 do
			local c = img:get(column, row);
			stroke(c);
			point(column+1, row+1);
		end
	end
end

function drawLine()
	local black = color(0)

	for row=0,img.height-1 do
		for column=0,img.width-1 do
			img:set(row, row, black);
		end
	end

	img:updatePixels();
end