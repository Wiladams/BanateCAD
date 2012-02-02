require "glsl"
require "Layout"
require "Actor"

local class = require "pl.class"

class.TextBox(Actor)

--[[
{
	Frame = {{0,0},{100,24}},
	Text = "Text",
	Font = GFont("Times", " ", 12),
	HAlignment = Alignment.Left,
	VAlignment = Alignment.Middle,
	TextColor = Color(0),
	BackColor = Color(0,0),
	BackgroundGraphic = nil,
}
--]]
function TextBox:_init(params)
	params = params or {
		Origin = {0,0},
		Extent = {100,24},
		Text = "Text",
		Font = GFont("Times", " ", 12),
		HAlignment = Alignment.Left,
		VAlignment = Alignment.Middle,
		TextColor = Color(0),
		BackColor = Color(0,0),
		BackgroundGraphic = nil,
	}

	params.Origin = params.Origin or {0,0}
	params.Extent = params.Extent or {80,20}

	self.Name = params.Name or "TextBox";
	self.BackgroundGraphic = params.BackgroundGraphic;
	self.Text = params.Text or "Text";
	self.Font = params.Font or GFont("Times", " ", 12)
	self.HAlignment = params.HAlignment or Alignment.Left;
	self.VAlignment = params.VAlignment or Alignment.Middle;

	self.TextColor = params.TextColor or Color(0);
	self.BackColor = params.BackColor or Color(0,0);
	self.TextAlignment = cd.CENTER


	self:super(params)


	self.TextOrigin = {self.Frame.Origin[1], self.Frame.Origin[2]}

	self:CalculateTextOrigin();
end

function TextBox:CalculateTextOrigin()
	local stringSize = self.Font:MeasureString(self.Text);
	--local xCenter = self.Frame.Origin[1] + self.Frame.Extent[1] / 2;
	--local yCenter = self.Frame.Origin[2] + self.Frame.Extent[2] / 2;
	local xCenter, yCenter = self.Frame:GetCenter();

	if self.HAlignment == Alignment.Left then
		self.TextOrigin[1] = self.Frame.Origin[1];
    elseif self.HAlignment == Alignment.Center then
		self.TextOrigin[1] = xCenter - stringSize[1] / 2;
    elseif self.HAlignment == Alignment.Right then
		self.TextOrigin[1] = self.Frame.Origin[1] + self.Frame.Extent[1] - stringSize[1];
	end

    if self.VAlignment == Alignment.Top then
		self.TextOrigin[2] = self.Frame.Origin[2]+stringSize[2]/2;
    elseif self.VAlignment == Alignment.Middle then
		self.TextOrigin[2] = yCenter;
    elseif self.VAlignment == Alignment.Bottom then
		self.TextOrigin[2] = self.Frame.Origin[2] + self.Frame.Extent[2] - stringSize[2]/2;
	end
end

-- Sizing
function TextBox:OnTopologyChanged()
	self:CalculateTextOrigin();
end


-- Graphic Overrides
function TextBox:RenderBackground(graphPort)
	if (self.BackgroundGraphic ~= nil) then
		self.BackgroundGraphic:Render(graphPort)
	elseif self.BackColor[4] ~= 0 then
		-- Draw a rectangle using background color
		graphPort:SetFillColor(self.BackColor)
		graphPort:SetStrokeColor(Color(0,0))
		graphPort:DrawRect(self.Frame.Origin[1], self.Frame.Origin[2],
			self.Frame.Extent[1], self.Frame.Extent[2]);
	end
end

function TextBox:Render(graphPort)
--print("TextBox:Render - ", self.TextColor);
--print("Frame: ", self.Frame)

	self:RenderBackground(graphPort);

	graphPort:SetFillColor(self.BackColor);
	self.Font:Render(graphPort);
	graphPort:SetTextAlignment(cd.WEST)
	graphPort:SetStrokeColor(self.TextColor);
	graphPort:DrawText(self.TextOrigin[1], self.TextOrigin[2], self.Text);
end


function TextBox:GetPreferredSize()
--[[
                //float width = Width;
                //float height = 0;
                //Graphics grfx = Graphics.FromHwnd(IntPtr.Zero);	// GraphPort of desktop
                //grfx.PageUnit = this.GraphicsUnit;
                //SizeF aSize = SizeF.Empty;

                //if (grfx != null)
                //{
                //    StringFormat strFormat = new StringFormat(StringFormat);
                //    //strFormat.Trimming = StringTrimming.Character;
                //    //aSize = grfx.MeasureString(fString, fFont, width, strFormat);
                //    int tmpWidth = (int)(width*grfx.DpiX);
                //    aSize = grfx.MeasureString(fString,fFont, new SizeF(width,Height),strFormat);
                //    //aSize = grfx.MeasureString(fString, fFont, tmpWidth,strFormat);
                //    // Get rid of the graphics object we created
                //    grfx.Dispose();
                //}
--]]

	-- Calculate the height using MeasureString
	return vec3(self.Frame.Extent[1], self.Frame.Extent[2],0);
end


