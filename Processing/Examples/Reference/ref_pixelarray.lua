local black = Color(255, 200, 0, 255)
local parray = PixelArray(256, 256, black)
parray:updatePixels()

function setup()
	size(1024, 768)
	background(53)

	parray:Render(30,30)
end