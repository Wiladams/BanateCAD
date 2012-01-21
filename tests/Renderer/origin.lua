background(230)
stroke(0)
fill(255)

local dx, dy = Processing.Renderer.canvas:GetOrigin()

textAlign(cd.NORTH_WEST)
text(dx, dy, "Text1")

line(0,0,0,100)

-- Move the origin
Processing.Renderer.canvas:Origin(10,18)
line(0,0,0,100)