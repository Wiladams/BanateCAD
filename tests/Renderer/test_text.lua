size(600,600)
background(230)
local txt = "Text"


textFont("Times")
textAlign(cd.NORTH_WEST)
text(0, 10, "Text")

--Processing.Renderer:PushMatrix()
--Processing.Renderer.Transformer:MakeIdentity()

--local y = Processing.Renderer.height-10
--Processing.Renderer.canvas:Text(0, y, "Text")
--Processing.Renderer:PopMatrix()

--Processing.Renderer:PushMatrix()
--Processing.Renderer:ResetTransform()
--Processing.Renderer:Scale(1, -1, 1)
--Processing.Renderer:Translate(0, -20, 0)
--Processing.Renderer:DrawText(0, Processing.Renderer.height - (height/2), txt)
--Processing.Renderer:PopMatrix()
--scale(1,-1)
--Processing.Renderer:FlipYAxis()

line(0,height/2, width, height/2)
line(width/2, 0, width/2, height)
line(10,100,500,500)