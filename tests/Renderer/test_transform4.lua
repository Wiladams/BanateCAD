function drawline()
	Processing.Renderer:DrawLine(0,0, 300, 300)
end

function applytransform(tfm)
	Processing.Renderer.canvas:Transform(tfm)
end

function flipyaxis()
print("flipyaxis")
	Processing.Renderer.Transformer:Scale(1, -1, 1)
	Processing.Renderer.Transformer:Translate(0, (Processing.Renderer.height-1), 0)
--print("Translate")
--print("Height: ", Processing.Renderer.height)
--Processing.Renderer.Transformer.CurrentMatrix:Print()


--print("Scale")
Processing.Renderer.Transformer.CurrentMatrix:Print();

	local tfm = Processing.Renderer.Transformer:Get2DMatrix()
	applytransform(tfm)
end

size(600,600)
background(230)
stroke(0)

--flipyaxis()

local tfm = Processing.Renderer.Transformer:Get2DMatrix()

--print(tfm)
--print(#tfm)
for i=1,#tfm do
	print(tfm[i])
end

drawline()

--translate(20, 10, 0)

--drawline()