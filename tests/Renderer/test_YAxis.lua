background(230)

Processing.Renderer:ResetTransform();

--Processing.Renderer.canvas:TransformTranslate(0, 600)
--Processing.Renderer.canvas:TransformTranslate(0, Processing.Renderer.height-1)
--Processing.Renderer:Scale(1,-1,1)
Processing.Renderer:FlipYAxis()

Processing.Renderer:DrawLine(0,0,100,100)

Processing.Renderer:DrawRect(10,10,100,100)

Processing.Renderer:Translate(10, 10)
Processing.Renderer:DrawRect(10,10,100,100)
