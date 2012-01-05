--
-- Typography
--
-- class PFont

-- Loading and Displaying

function createFont()
end

function loadFont()
end

function text(x, y, txt)
	Processing.DrawText(x, y, txt)
end



-- Attributes

function textAlign(align, yalign)
	yalign = yalign or Processing.TextYAlignment

	Processing.TextAlignment = align
	Processing.TextYAlignment = yalign
	Processing.SetTextAlignment(align, yalign)
end

function textLeading(leading)
	Processing.TextLeading = leading
end

function textMode(mode)
	Processing.TextMode = mode
end

function textSize(asize)
	Processing.TextSize = asize
end

function textWidth(astring)
	return Processing.GetTextWidth(astring)
end

function textFont(fontname)
	return Processing.SetFontName(fontname)
end

-- Metrics
--[[
function textAscent()
end

function textDescent()
end
--]]
