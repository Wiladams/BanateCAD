function drawline()
	Processing.Renderer:DrawLine(50,1, 50, 750)
end

function applytransform(tfm)
	Processing.Renderer.canvas:Transform(tfm)
end

size(600,600)
background(230)
stroke(0)

drawline()

translate(20, 10, 0)

drawline()
