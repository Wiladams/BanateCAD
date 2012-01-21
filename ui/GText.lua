local class = require "pl.class"
local IMRenderer = require "IMRenderer"

class.GText()

GText._TextMeasurer = IMRenderer(1,1)


function GText:_init(atext, pos, params)
	params = params or {}
-- Text
	self.Text = atext

-- Position
	self.Position = pos

-- TextAlignment
	self.Alignment = params.Alignment or cd.BASE_LEFT
-- TextYAlignment
	self.YAlignment = params.YAlignment or cd.CENTER

-- FontName
	self.FontName = params.FontName or "Times"

-- FontStyle
	self.FontStyle = params.FontStyle or " "

-- FontSize
	self.FontSize = params.FontSize or 9

	self.Size = self:MeasureString()
end

-- Measure the size of a string
function GText.MeasureString(self)
	local renderer = GText._TextMeasurer

	local fontdesc = self.FontName..', '..self.FontStyle..' '..self.FontSize

	--textFont(fontdesc)
	renderer:SetFont(fontdesc)
	local txtsize = GText._TextMeasurer:MeasureString(self.Text)

	return txtsize
end

function GText.GetDescription(self)
	local desc = string.format("%s, %s %d", self.FontName, self.FontStyle, self.FontSize);
	return desc
end

function GText:Render(renderer)
	renderer = renderer or defaultrenderer
	if not renderer then return end

	local fontdesc = self:GetDescription();

	renderer:SetFont(fontdesc)
	renderer:SetTextAlignment(self.Alignment)
	renderer:DrawText(self.Position[1], self.Position[2], self.Text)
end
