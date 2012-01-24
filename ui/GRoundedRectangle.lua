local class = require "pl.class"


class.GRoundedRectangle()

function GRoundedRectangle:_init(...)
	if arg.n > 1 then
		self.Origin = {arg[1],arg[2]}
		self.Extent = {arg[3],arg[4]}
		self.Radius = arg[5] or 0
		self.FillColor = arg[6] -- or Color(255, 255, 255)
	elseif arg.n == 1 then
		local params = arg[1]
		self.Origin = params.Origin or {0,0,0}
		self.Extent = params.Extent or {0,0,0}
		self.Radius = params.Radius or 0
		self.FillColor = params.FillColor --or Color(255,255,255)
	end

	self.Figure = ShapeBuilder()

	local sb = self.Figure;

	local x = self.Origin[1]
	local y = self.Origin[2]
	local w = self.Extent[1]
	local h = self.Extent[2]
	local r = self.Radius

	sb:AddVertex({x,self.Origin[1]+r,0})
	sb:LineTo({x,y+h-r,0})
	sb:Bezier2({x,y+h,0}, {x+r,y+h,0})
	sb:LineTo({x+w-r, y+h,0})
	sb:Bezier2({x+w,y+h,0},{x+w,y+h-r,0})
	sb:LineTo({x+w,y+r,0})
	sb:Bezier2({x+w,y,0},{x+w-r,y,0})
	sb:LineTo({x+r,y,0})
	sb:Bezier2({x,y,0},{x,y+r,0})
end

function GRoundedRectangle.Render(self, graphPort)
	if self.FillColor then
		graphPort:SetFillColor(self.FillColor)
	end
	graphPort:DrawPolygon(self.Figure.Vertices);
end
