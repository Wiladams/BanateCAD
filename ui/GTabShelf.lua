--[[
	GTabShelf.lua
--]]

local class = require "pl.class"
require "TextBox"

--[[
{
	Font = GFont("Times", " ", 18),
	TabHeight = 24,
	TabLabels = {},
	ActiveTab = 1,
	ShowHightlight = true,
}
--]]

class.GTabShelf(Actor)

function GTabShelf:_init(params)
params = params or {
	Font = GFont("Times", " ", 18),
	TabHeight = 24,
	TabLabels = {},
	ActiveTab = 1,
	Margin = 16,
	ShowHighlight = true,
}

	params.Origin = params.Origin or {0,100}
	params.Extent = params.Extent or {400, 24}

	self:super(params);

	self.Baseline = params.Origin[2];

	self.Font = params.Font;
	self.TabHeight = params.TabHeight;
	self.TabLabels = params.TabLabels;
	self.ActiveTab = params.ActiveTab;
	self.Margin = params.Margin or 8;
	self.ShowHighlight = params.ShowHighlight or false

	-- Create the labels
	-- for each text item, there is position, and text
	local textx = self.Frame.Left;
	local texty = self.Frame.Top+self.TabHeight-self.TabHeight;
	local textsize = {0,0}

	self.Tabs = {}
	for i,label in ipairs(self.TabLabels) do
		local tabtext = label.Name
		textsize = self.Font:MeasureString(tabtext)
		local tabwidth = textsize[1] + 2*self.Margin
		local origin = {textx, self.Baseline-self.TabHeight}
		local extent = {tabwidth,self.TabHeight}
		local tbox = TextBox({
			Origin = origin,
			Extent = extent,
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

		self:AddMember(label.Graphic);

		textx = textx + tabwidth
	end
	self.TabCount = #self.Tabs;
end

function GTabShelf:Offset(dx, dy)
	self.Frame:Offset(dx, dy)

	-- Reset all the text fields
	for _,tab in ipairs(self.Tabs) do
		tab.TabLabel:Offset(dx, dy);
	end
end


function GTabShelf:AddMember(member)
	if not member then return end

	-- Assume the new member has dimensions specified relative
	-- to our frame.  So, offset their boundary by our WorldFrame
	-- origin
	member:Offset(self.Frame.Origin[1], self.Frame.Origin[2]+self.TabHeight)

	-- Expand our world frame to recognize the new member
	self.Frame:Union(member.Frame);

	-- Expand bouding frame

	-- Add the member to the ensemble
	table.insert(self.Members, member);
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
				--sb:AddVertex({left, top,0})
				sb:AddVertex({left, bottom,0})
				sb:LineTo({left, top,0})
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
			sb:LineTo({self.Frame.Width, bottom, 0})
		end
	end

	graphPort:SetStrokeColor(Color(127))
	sb:Render(graphPort)
end

function GTabShelf:RenderSelf(graphPort)
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
		if tablabel:Contains(x,y) then
			return i
		end
	end
	return nil
end

function GTabShelf:SetActiveTab(tabnum)
	local oldGraphic = self.Tabs[self.ActiveTab].TabGraphic;

	if oldGraphic then
		oldGraphic:SetActive(false);
	end

	self.ActiveTab = tabnum
	local newgraphic = self.Tabs[self.ActiveTab].TabGraphic;

	if newgraphic then
		newgraphic:SetActive(true);
	end
end

function GTabShelf:MouseActivity(ma)
	local tabnum = self:WhichTab(ma.X, ma.Y)

	-- If it's one of our own tabs, then perform
	-- appropriate actions for the tab
	if tabnum then
		if ma.ActivityType == MouseActivityType.MouseDown then
			local tabnum = self:WhichTab(ma.X, ma.Y)
			if tabnum then
				self:SetActiveTab(tabnum)
			end
		end

		if ma.ActivityType == MouseActivityType.MouseMove then
			if tabnum ~= self.ActiveTab then
				self.HighlightTab = tabnum
			else
				self.HighlightTab = nil
			end
		end
	else
		-- Send mouse activity to all members
		for i,member in ipairs(self.Members) do
			member:MouseActivity(ma)
		end
	end
end
