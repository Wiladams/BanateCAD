function drawline()
	Processing.Renderer:DrawLine(50,1, 50, 750)
end

function applytransform(tfm)
	Processing.Renderer.canvas:Transform(tfm)
end

size(600,600)
background(230)
stroke(0)

Processing.Renderer.Transformer:Clear()
local tfm = Processing.Renderer.Transformer:Get2DMatrix()
applytransform(tfm)

drawline()

Processing.Renderer.Transformer:Translate(10,10,0)
tfm = Processing.Renderer.Transformer:Get2DMatrix()
applytransform(tfm)

--print(tfm)
--print(#tfm)
for i=1,#tfm do
	print(tfm[i])
end

drawline()
