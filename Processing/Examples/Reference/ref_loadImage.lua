local b = PImage.new("csg1.png")
local starhead = PImage.new("starhead.png")
local proccer = PImage.new("Processing1.PNG")

function setup()
	size(1024, 768)

	--rotate(radians(20))
	image(b, 30, 30)

	image(starhead, 100, 100)

	image(proccer, 300,300)
end