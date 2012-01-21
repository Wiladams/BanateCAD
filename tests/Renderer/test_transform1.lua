local w = Processing.Renderer.width
local h = Processing.Renderer.height

-- Identity transform
-- {sx, r, r, sy, dx, dy}
local mtx = {1,0,0,1,0,0}

function reidentity()
local tfm = {1,0,0,1,0,0}
	retransform(tfm)
end

function retransform(mtx)
	Processing.Renderer.canvas:Transform(mtx)
end

function retranslate(tx, ty)
	mtx[5] = mtx[5] + tx
	mtx[6] = mtx[6] + ty
	retransform(mtx)
end

function rescale(sx, sy)
	mtx[1] = sx
	mtx[4] = sy
	retransform(mtx)
end

background(230)
stroke(0)

reidentity()
retranslate(0, h)
rescale(1,-1,1)

Processing.Renderer:DrawLine(0,0,(w-1)/2, (h-1)/2)

--Processing.Renderer:TransformToText();
--Processing.Renderer:Scale(1, -1, 1);

function setup()
end