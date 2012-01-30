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
	ShowHightlight = true,
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
	ShowHighlight = true,
}

	self.Font = params.Font;
	self.TabHeight = params.TabHeight;
	self.ShelfWidth = params.ShelfWidth;
	self.TabLabels = params.TabLabels;
	self.ActiveTab = params.ActiveTab;
	self.Baseline = params.Baseline;
	self.Margin = params.Margin;
	self.ShowHighlight = params.ShowHighlight or false

	-- Create the labels
	-- for each text item, there is position, and text
	local textx = 0;
	local texty = self.Baseline-self.Margin;
	local textsize = {0,0}

	self.Tabs = {}
	for i,label in ipairs(self.TabLabels) do
		local tabtext = label.Name
		textsize = self.Font:MeasureString(tabtext)
		local tabwidth = textsize[1] + 2*self.Margin
		local tabFrame = {{textx, self.Baseline-self.TabHeight}, {tabwidth,self.TabHeight}}
		local tbox = TextBox({
			Frame = {{textx, self.Baseline-self.TabHeight},{tabwidth,self.TabHeight}},
			Text = tabtext,
			Font = self.Font,
			HAlignment = Alignment.Center,
			VAlignment = Alignment.Middle,
			TextColor = Color(0),
			BackColor = Color(200,0),
			BackgroundGraphic = nil})


		local tabEntry = {
			TabLabel = tbox,
			TabGraphic = label.Graphic,
		}
		table.insert(self.Tabs, tabEntry);

		textx = textx + tabwidth
	end
	self.TabCount = #self.Tabs;
end


function GTabShelf:RenderBackground(graphPort)

	-- Draw halo highlight
	if self.ShowHighlight and (self.ActiveTab ~= self.HighlightTab) then
		local tab = self.Tabs[self.HighlightTab]
		if tab then
			local centerx,centery = tab.TabLabel.Frame:GetCenter()
			local w = tab.TabLabel.Frame.Width;
			local h = tab.TabLabel.Frame.Height;

			graphPort:SetFillColor(Color(230))
			graphPort:SetStrokeColor(Color(0,0))
			graphPort:DrawEllipse(centerx,centery,w,h)
		end
	end

	local sb = ShapeBuilder(ShapeBuilder.LINES);

	for i,tab in ipairs(self.Tabs) do
		local left = tab.TabLabel.Frame.Left
		local right = tab.TabLabel.Frame.Right
		local top = tab.TabLabel.Frame.Top
		local bottom = tab.TabLabel.Frame.Bottom

		if i == self.ActiveTab then
			if i == 1 then
				sb:AddVertex({left, top,0})
				sb:LineTo({right, top,0})
				sb:LineTo({right, bottom, 0})
			else
				sb:AddVertex({left, bottom,0})
				sb:LineTo({left, top,0})
				sb:LineTo({right, top,0})
				sb:LineTo({right, bottom, 0})
			end
		else
			if i == 1 then
				sb:AddVertex({left, bottom,0})
			end
			sb:LineTo({right, bottom, 0})
		end
		if i == self.TabCount then
			sb:LineTo({self.ShelfWidth, bottom, 0})
		end
	end

	graphPort:SetStrokeColor(Color(127))
	sb:Render(graphPort)
end

function GTabShelf:Render(graphPort)
	self:RenderBackground(graphPort)

	self.Font:Render(graphPort)
	graphPort:SetTextAlignment(cd.BASE_CENTER);
	for i,tab in ipairs(self.Tabs) do
		if i == self.ActiveTab then
			tab.TabLabel.TextColor = Color(0)
		else
			tab.TabLabel.TextColor = Color(127)
		end

		tab.TabLabel:Render(graphPort);
	end

end

function GTabShelf:WhichTab(x,y)
	for i,tab in ipairs(self.Tabs) do
		local tablabel = tab.TabLabel
		if tablabel.Frame:Contains(x,y) then
			return i
		end
	end
	return nil
end

function GTabShelf:MouseActivity(ma)
	local tabnum = self:WhichTab(ma.X, ma.Y)
	--if not tabnum then return end

	if ma.ActivityType == MouseActivityType.MouseDown then
		if tabnum then
			self.ActiveTab = tabnum
		end
	end

	if ma.ActivityType == MouseActivityType.MouseMove then
		if tabnum ~= self.ActiveTab then
			self.HighlightTab = tabnum
		else
			self.HighlightTab = nil
		end
	end
end
