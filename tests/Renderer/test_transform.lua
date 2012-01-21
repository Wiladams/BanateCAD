local w = Processing.Renderer.width
local h = Processing.Renderer.height

size(600,600)
background(230)


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

function rescale(sx, sy)
	mtx[1] = sx
	mtx[4] = sy
	retransform(mtx)
end

function retranslate(tx, ty)
	mtx[5] = mtx[5] + tx
	mtx[6] = mtx[6] + ty
	retransform(mtx)
end

reidentity()
Processing.Renderer:DrawLine(0,0,w/2, h/2)
Processing.Renderer:DrawText(0,0,"Text")

retranslate(0, h/2)
Processing.Renderer:DrawLine(0,0,w/2, h/2)
Processing.Renderer:DrawText(0,0,"Text")

retranslate(0, -h/4)
Processing.Renderer:DrawLine(0,0,w/2, h/2)
Processing.Renderer:DrawText(0,0,"Text")

Processing.Renderer:TransformToText()
Processing.Renderer:SetTextAlignment(cd.NORTH_WEST)
Processing.Renderer:DrawText(0,0,"Text")
Processing.Renderer:TransformFromText()