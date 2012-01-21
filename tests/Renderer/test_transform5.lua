function drawline()
	Processing.Renderer:DrawLine(0,0, 300, 300)
end

function applytransform(tfm)
	Processing.Renderer.canvas:Transform(tfm)
end

size(600,600)
background(230)
stroke(0)

local tfm = Processing.Renderer.Transformer:Get2DMatrix()

for i=1,#tfm do
	print(tfm[i])
end

drawline()

translate(20, 10, 0)

drawline()