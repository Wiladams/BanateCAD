function printtransform()
	local mat = Processing.Renderer.Transformer:Get2DMatrix()
	for i=1,#mat do
		print(mat[i])
	end
end

function setup()
	size(600, 400);
	background(210, 177, 68);
	strokeWeight(1)
--end

--function draw()
	pushMatrix()
	fill(139, 49, 30);
	rotate(radians(20));

printtransform()

	rect(150, 100, 250, 150);
	popMatrix()
end