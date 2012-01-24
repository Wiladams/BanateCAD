local class = require "pl.class"

class.GBracket()

function GBracket:_init(w,h)
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

	self.sb = sb;
end

function GBracket:Render(graphPort)
	self.sb:Render(graphPort)
end
