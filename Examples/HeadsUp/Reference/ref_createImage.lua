local img = createImage(66, 66, RGB);
img:loadPixels();
for row=1,img.height do
	for column=1, img.width do
		img:set(column, row, color(0, 90, 102))
	end
end


img:updatePixels();
image(img, 17, 17);