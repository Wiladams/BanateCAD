-- GGridPaper.lua

local class = require "pl.class"

class.GGridPaper(Actor)

--[[
	Origin = {0,0},
	Extent = {1024, 768},
	MinorGrid = 8,
	MajorGrid = 40,
	MinorColor = Color(127),
	MajorColor = Color(53),
--]]

function GGridPaper:_init(params)
	params = params or {}

	Actor._init(self, params);

	self.MinorGrid = params.MinorGrid or 8;
	self.MajorGrid = params.MajorGrid or 40;

	self.MinorColor = params.MinorColor or Color(127);
	self.MajorColor = params.MajorColor or Color(255);
end

function GGridPaper:RenderSelf(graphPort)
	-- draw minor grid
	graphPort:SetLineWidth(1)
	graphPort:SetStrokeColor(self.MinorColor)
	-- Vertical bars
	for col = self.Frame.Left,self.Frame.Right, self.MinorGrid do
		graphPort:DrawLine(col, self.Frame.Top, col, self.Frame.Bottom)
	end
	-- Horizontal bars
	for row = self.Frame.Top,self.Frame.Bottom, self.MinorGrid do
		graphPort:DrawLine(self.Frame.Left, row, self.Frame.Right, row)
	end

	-- draw major grid
	graphPort:SetLineWidth(1)
	graphPort:SetStrokeColor(self.MajorColor)
	-- Vertical bars
	for col = self.Frame.Left+self.MajorGrid,self.Frame.Right, self.MajorGrid do
		graphPort:DrawLine(col, self.Frame.Top, col, self.Frame.Bottom)
	end
	-- Horizontal bars
	for row = self.Frame.Top+self.MajorGrid,self.Frame.Bottom, self.MajorGrid do
		graphPort:DrawLine(self.Frame.Left, row, self.Frame.Right, row)
	end
end

