local class = require "pl.class"
require "IMRenderer"

local FontWeight =
{
    DontCare = 0,
    THIN = 100,
    EXTRALIGHT = 200,
    ULTRALIGHT = 200,
    LIGHT = 300,
    NORMAL = 400,
    REGULAR = 400,
    MEDIUM = 500,
    DEMIBOLD = 600,
    SEMIBOLD = 600,
    BOLD = 700,
    ULTRABOLD = 800,
    EXTRABOLD = 800,
    HEAVY = 900,
}

local FontStyle =
{
    Regular = 0,
    Bold = 1,
    Italic = 2,
    Underline = 4,
    Strikethrough = 16,
}

class.GFont()

GFont._TextMeasurer = IMRenderer(1,1)


function GFont:_init(fontname, fontstyle, fontsize)
	params = params or {}

	-- FontName
	self.FontName = fontname or "Times"

	-- FontStyle
	self.FontStyle = fontstyle or " "

	-- FontSize
	self.FontSize = fontsize or 9

	self.Description = self:GetDescription();

	self:GetFontSize()
end

function GFont.GetFontSize(self)
	local renderer = GFont._TextMeasurer;

	renderer:SetFont(self.Description);
	self.FontHeight, self.FontAscent, self.FontDescent = renderer:GetFontDimension();
end

-- Measure the size of a string
function GFont.MeasureString(self, txt)
	local renderer = GFont._TextMeasurer


	renderer:SetFont(self.Description)
	local txtsize = renderer:MeasureString(txt)

	return txtsize
end

function GFont.GetDescription(self)
	local fontdesc = string.format("%s, %s %d", self.FontName, self.FontStyle, self.FontSize);
	return fontdesc;
end

function GFont.Render(self, graphport)
	graphport:SetFont(self.Description)
end
