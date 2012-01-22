local class = require "pl.class"

--require "GeometricObject"
--require "Rectangle"

class.GRoundedRectangle()

function GRoundedRectangle:_init(x,y,w,h,radius)
	self.Origin = {x,y}
	self.Extent = {w,h}
	self.Radius = radius

	self.Builder = ShapeBuilder()

	local sb = self.Builder;

	sb:AddVertex({x,y+r,0})
	sb:AddVertex({x,y+h-r})
	sb:Bezier({x,y+h,0}, {x,y+h,0}, {x+r,y+h,0})
end

function GRoundedRectangle.Render(self, graphPort)
	local x = self.Origin[1]
	local y = self.Origin[2]
	local w = self.Dimension[1]
	local h = self.Dimension[2]
	local r = self.Radius

	-- Vertical lines
	graphPort:DrawLine(x,y+r, x,y+h-r)
	graphPort:DrawBezier({x,y+h-r,0},{x,y+h,0},{x,y+h,0},{x+r,y+h,0})

	graphPort:DrawLine(x+w,y+r, x+w,y+h-r)
	graphPort:DrawBezier({x+w-r,y+h,0},{x+w,y+h,0},{x+w,y+h,0},{x+w,y+h-r,0})

	-- horizontal lines
	graphPort:DrawLine(x+r, y+h, x+w-r, y+h)
	graphPort:DrawBezier({x+w,y+r,0},{x+w,y,0},{x+w,y,0},{x+w-r,y,0})

	graphPort:DrawLine(x+r, y, x+w-r, y)
	graphPort:DrawBezier({x+r,y,0},{x,y,0},{x,y,0},{x,y+r,0})
end
