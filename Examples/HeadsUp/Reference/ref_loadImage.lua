local b = loadImage("csg1.png")
local starhead = loadImage("starhead.png")
local proccer = loadImage("Processing1.PNG")

function setup()
	size(1024, 768)
	background(53)

	--rotate(radians(20))
	image(b, 30, 30)

	image(starhead, 100, 100)

	image(proccer, 300,300)
end