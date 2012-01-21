size(600,600)
background(230)

--Processing.Renderer:ResetTransform();
--Processing.Renderer:FlipYAxis()

function DrawCrosshairs()
	--Processing.Renderer:DrawLine(width/2, 0, width/2, height-1)
	--Processing.Renderer:DrawLine(0, height/2, width-1, height/2)

	line(width/2, 0, width/2, height-1)
	line(0, height/2, width-1, height/2)
end


DrawCrosshairs()

-- translate to center
fill(255)
--Processing.Renderer:Translate(width/2, height/2)
translate(width/2, height/2)
--Processing.Renderer:DrawRect(-200, -200, 400, 400)
rect(-200, -200, 400, 400)

local gray = 0
local dir = 8

function draw()
	gray = gray + dir

	if gray > 255 or gray < 0 then
		dir = -dir
	else
		fill(gray)

		--Processing.Renderer:Rotate(0,0,radians(2))
		rotate(radians(2))
		--Processing.Renderer:DrawRect(-100, -100, 200, 200)
		rect(-100, -100, 200, 200)
	end
end