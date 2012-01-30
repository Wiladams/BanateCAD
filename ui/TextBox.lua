require "glsl"
require "Layout"
local class = require "pl.class"

class.TextBox()

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
	self.Name = "TextBox";
	local frame = params.Frame or {{0,0}, {100,20}}
	self.Frame = Rectangle(frame[1][1], frame[1][2], frame[2][1], frame[2][2]);

	self.BackgroundGraphic = params.BackgroundGraphic;
	self.Text = params.Text;
	self.Font = params.Font;
	self.HAlignment = params.HAlignment;
	self.VAlignment = params.VAlignment;

	self.TextColor = params.TextColor or Color(0);
	self.BackColor = params.BackColor or Color(0,0);

	self.TextOrigin = {self.Frame.Origin[1], self.Frame.Origin[2]}
	self.TextAlignment = cd.CENTER

	self:CalculateTextOrigin();
end

function TextBox:CalculateTextOrigin()
	local stringSize = self.Font:MeasureString(self.Text);
	local xCenter = self.Frame.Origin[1] + self.Frame.Extent[1] / 2;
	local yCenter = self.Frame.Origin[2] + self.Frame.Extent[2] / 2;

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
	self:RenderBackground(graphPort);

	graphPort:SetFillColor(self.BackColor);
	self.Font:Render(graphPort);
	graphPort:SetTextAlignment(cd.WEST)
	graphPort:SetStrokeColor(self.TextColor);
--print(self.TextColor);
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


