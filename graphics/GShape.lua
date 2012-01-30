require "Rectangle"
require "Color"

local class = require "pl.class"

class.GShape()

--[[
Origin
Extent
--]]

function GShape:_init(params)
	params = params or {
			Origin = {-.5,-.5},
			Extent = {1,1},
		}

--print(string.format("GShape:_init Origin: %dx%d   Extent: %dx%d",
--	params.Origin[1], params.Origin[2],
--	params.Extent[1], params.Extent[2]))

	self.Frame = Rectangle(params.Origin, params.Extent)

--print("GShape:_init Frame: ", self.Frame)

	self.BackgroundFill = params.BackgroundFill or Color(0,0)
	self.BackgroundStroke = params.BackgroundStroke or Color(0)
	self.FillColor = params.FillColor or Color(255)
	self.StrokeColor = params.StrokeColor or Color(0)
	self.StrokeWidth = params.StrokeWidth or 1
end

function GShape:Contains(x,y)
	return self.Frame:Contains(x,y)
end

function GShape:RenderBackground(graphPort)
	graphPort:SetFillColor(self.BackgroundFill);
	graphPort:SetStrokeColor(self.BackgroundStroke);
	graphPort:DrawRect(self.Frame.Left, self.Frame.Top, self.Frame.Width, self.Frame.Height)
end

function GShape:RenderSelf(graphPort)
end

function GShape:RenderForeground(graphPort)
end

function GShape:Render(graphPort)
	self:RenderBackground(graphPort)
	self:RenderSelf(graphPort)
	self:RenderForeground(graphPort)
end



class.GFigure(GShape)

function GFigure:_init(params)
	params = params or {}
	self:super(params)

	self.Shapes = params.Shapes or {}
end

function GFigure:AddShape(ashape)
	table.insert(self.Shapes, ashape)
end

function GFigure:Render(graphPort)
	for _,shape in self.Shapes do
		shape:Render(graphPort);
	end
end




