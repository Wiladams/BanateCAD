require "glsl"

local class = require "pl.class"

class.GraphicArrow()


--[[
	{
		Name = "GraphicArrow",
		Frame = {{0,0},{200, 150}},
		ArrowDepth = 50,
		DropMargin = 25,
		FillColor = Color(255),
		BorderColor = Color(0),
	}
--]]
function GraphicArrow:_init(params)
	params = params or {}
	local frame = params.Frame or {{0,0},{100,100}}


	self.Frame = Rectangle(frame[1], frame[2])

	self.ArrowDepth = params.ArrowDepth or self.Frame.Extent[2] * 0.1;
	self.DropMargin = params.DropMargin or self.ArrowDepth / 2;

	self.FillColor = fillColor or Color(255,255,255);
	self.BorderColor = borderColor or Color(0,0,0);

	--self.Pen = GPen(borderColor);
	--self.Brush = GBrush(BrushStyle.Solid, HatchStyle.Vertical, fillColor, Guid.NewGuid());

	local x = self.Frame.Origin[1];
	local y = self.Frame.Origin[2];
	local right = x + self.Frame.Extent[1];
	local bottom = y + self.Frame.Extent[2];

    self.Vertices = {
		vec3(x, y + self.DropMargin),
		vec3(right - self.ArrowDepth, y + self.DropMargin),
		vec3(right - self.ArrowDepth, y),
		vec3(right, y + (self.Frame.Extent[2] / 2)),
		vec3(right - self.ArrowDepth, bottom),
		vec3(right - self.ArrowDepth, bottom - self.DropMargin),
		vec3(x, bottom - self.DropMargin),
		vec3(x, y + self.DropMargin),

        }
end


function GraphicArrow:GetClientFrame()
	local rect = Rectangle(
		self.Frame.Origin[1]+2,
		self.Frame.Origin[2]+self.DropMargin + 2,
		self.Frame.Extent[1] - self.ArrowDepth - 4,
		self.Frame.Extent[2] - (self.DropMargin * 2) - 4);

	return rect;
end


function GraphicArrow:Render(graphPort)
	--graphPort.SetPen(fPen);
    --graphPort.SetBrush(fBrush);
	graphPort:SetStrokeColor(self.BorderColor)
	graphPort:SetFillColor(self.FillColor)
    graphPort:DrawPolygon(self.Vertices);
end

