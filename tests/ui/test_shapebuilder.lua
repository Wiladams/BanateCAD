local sb = ShapeBuilder()

background(255)

sb:AddVertex({10,10,0})
sb:LineTo({180,10,0})
sb:Bezier2({200,10,0},{200,30,0})

sb:Close(ShapeBuilder.LINES)

fill(0,255,255)
--sb:Render(Processing.Renderer)

function createBracket(w,h)
	local sb = ShapeBuilder()
	
	sb:AddVertex({0,h,0})
	sb:Bezier({0,3/4*h,0},{1/4*h, h/2,0},{h/2,h/2,0})

	sb:LineTo({w/2-h/2, h/2,0})
	sb:Bezier2({w/2, h/2,0}, {w/2, 0,0})

	sb:Bezier2({w/2,h/2,0},{w/2+h/2,h/2,0})
	sb:LineTo({w-h/2,h/2,0})

	-- Final curl
	sb:Bezier({w,h/2,0},{w,h,0},{w,h,0})

	sb:Close(ShapeBuilder.LINES)
	--sb:Close(ShapeBuilder.CLOSE)
	
	return sb
end


translate(10,-30)
--rotate(radians(-10))
local br1 = createBracket(140, 24)
br1:Render(Processing.Renderer)

translate(10,-30)
--rotate(radians(-10))
local br2 = createBracket(160, 32)
br2:Render(Processing.Renderer)

translate(10,-30)
--rotate(radians(-10))
local br2 = createBracket(180, 48)
br2:Render(Processing.Renderer)
