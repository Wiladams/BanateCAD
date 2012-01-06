local class = require "pl.class"

class.GText()

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
end

function GText:render(renderer)
	renderer = renderer or defaultrenderer
	local fontdesc = self.FontName..', '..self.FontStyle..' '..self.FontSize

print(fontdesc)
--print(self.Alignment)
--print(self.Position[1], self.Position[2])

	--textFont(fontdesc)
	renderer:SetFont(fontdesc)
	renderer:SetTextAlignment(self.Alignment)
	renderer:DrawText(self.Position[1], self.Position[2], self.Text)
end
