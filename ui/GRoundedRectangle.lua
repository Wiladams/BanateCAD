local class = require "pl.class"

--require "GeometricObject"
--require "Rectangle"

class.GRoundedRectangle()

function GRoundedRectangle:_init(x,y,w,h,r)
	self.Origin = {x,y}
	self.Extent = {w,h}
	self.Radius = r

	self.Builder = ShapeBuilder()

	local sb = self.Builder;

	sb:AddVertex({x,y+r,0})
	sb:AddVertex({x,y+h-r,0})
	sb:Bezier({x,y+h,0}, {x,y+h,0}, {x+r,y+h,0})
end

function GRoundedRectangle.Render(self, graphPort)
	graphPort:DrawPolygon(self.Builder.Vertices);
end
