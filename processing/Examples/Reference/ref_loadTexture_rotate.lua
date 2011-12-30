local b = Texture("csg1.png")
local starhead = Texture("starhead.png")
local proccer = Texture("Processing1.PNG")

function setup()
	size(1024, 768)
	background(53)
	frameRate(20);
end

function drawTexture(tex, offsetx, offsety, deg)
	-- Save current transform
	pushMatrix();

	-- Apply transform to make image at center 
	-- for rotation
	translate(offsetx + tex.width/2, offsety+tex.height/2);
	rotate(radians(deg*frameCount));

	-- Draw the image
	Processing.DrawTexture(tex, -tex.width/2, -tex.height/2);

	-- Reset the transform
	popMatrix();
end

function draw()
	background(53)

	drawTexture(proccer, 300, 300, 360/160)
	drawTexture(starhead, 150, 150, -360/40)
	drawTexture(b, 30, 30, 360/20)
end