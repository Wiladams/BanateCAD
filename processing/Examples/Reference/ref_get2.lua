local img = PImage("csg1.png")

function setup()
	background(55);
	Processing.DrawTexture(img)

	img:loadPixels();
	local cp = img:get(30, 30);
	fill(cp);
	rect(30, 30, 55, 55);
end

