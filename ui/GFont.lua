local class = require "pl.class"
require "IMRenderer"

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
end

-- Measure the size of a string
function GFont.MeasureString(self, txt)
	local renderer = GFont._TextMeasurer

print(self.Description);

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
