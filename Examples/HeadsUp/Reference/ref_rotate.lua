size(600, 600);
background(230)

stroke(127)
line(width/2, 0, width/2, height)
line(0, height/2, width, height/2)

translate(width/2,height/2)
--rotate(radians(4))
Processing.Renderer.canvas:TransformRotate((10))

stroke(0)
noFill()
rect(-50,-50,100,100)