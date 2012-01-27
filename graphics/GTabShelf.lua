--[[
	GTabShelf.lua
--]]

local class = require "pl.class"
require "TextBox"

--[[
{
	Font = GFont("Times", " ", 18),
	TabHeight = 24,
	ShelfWidth = 400,
	TabLabels = {},
	ActiveTab = 1,
}
--]]

class.GTabShelf()

function GTabShelf:_init(params)
params = params or {
	Font = GFont("Times", " ", 18),
	TabHeight = 24,
	ShelfWidth = 400,
	TabLabels = {},
	ActiveTab = 1,
	Baseline = 100,
	Margin = 16,
}

	self.Font = params.Font;
	self.TabHeight = params.TabHeight;
	self.ShelfWidth = params.ShelfWidth;
	self.TabLabels = params.TabLabels;
	self.ActiveTab = params.ActiveTab;
	self.Baseline = params.Baseline;
	self.Margin = params.Margin;

	-- Create the labels
	-- for each text item, there is position, and text
	local textx = 0;
	local texty = self.Baseline-self.Margin;
	local textsize = {0,0}

	self.Tabs = {}
	for i,label in ipairs(self.TabLabels) do
		textsize = self.Font:MeasureString(label)
		local tabwidth = textsize[1] + 2*self.Margin
		local tabFrame = {{textx, self.Baseline-self.TabHeight}, {tabwidth,self.TabHeight}}
		local tbox = TextBox({
			Frame = {{textx, self.Baseline-self.TabHeight},{tabwidth,self.TabHeight}},
			Text = label,
			Font = self.Font,
			HAlignment = Alignment.Center,
			VAlignment = Alignment.Middle,
			TextColor = Color(0),
			BackColor = Color(200,255),
			BackgroundGraphic = nil})

		textx = textx + tabwidth
		table.insert(self.Tabs, tbox);
	end
end


function GTabShelf:RenderBackground(graphPort)
	graphPort:SetStrokeColor(Color(127));
	graphPort:DrawLine(0, self.Baseline, width, self.Baseline);
end

function GTabShelf:Render(graphPort)
	self:RenderBackground(graphPort)

	self.Font:Render(graphPort)
	graphPort:SetTextAlignment(cd.BASE_CENTER);
	for i,tabentry in ipairs(self.Tabs) do
		if i == self.ActiveTab then
			tabentry.TextColor = Color(0)
		else
			tabentry.TextColor = Color(127)
		end

		tabentry:Render(graphPort);
	end

end
