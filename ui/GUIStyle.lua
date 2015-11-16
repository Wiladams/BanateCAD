local Colors = require "Colors"
local ColorUtils = require "ColorUtils"

--[[
/*
* <dt> base
* <dd> The base color is the color that is used as the "dominant" color
*      for graphical objects. For example, a button's text is drawn on top
*      of this color when the button is "up".
* <dt> highlight
* <dd> A lighter rendition of the base color used to create a highlight in
*      pseudo 3D effects.
* <dt> shadow
* <dd> A darker rendition of the base color used to create a shadow in pseudo
*      3D effects.
* <dt> background
* <dd> The color used for background (or inset) <I>items</I> in a drawing
*      scheme (rather than as a typical background area per se).  For example,
*      the background of a slider (the "groove" that the thumb slides in)
*      is drawn in this color.  [This name probably needs to be changed.]
* <dt>
* <dd> Note: the colors: base, highlight, shadow, and background are designed
*      to be related, typically appearing to be the same material but with
*      different lighting.
* <dt> foreground
* <dd> The color normally drawn over the base color for foreground items such
*      as textual labels.  This color needs to contrast with, but not clash
*      with the base color.
* <dt> text_background
* <dd> The color that serves as the background for text editing areas.
* <dt> splash
* <dd> A color which is designed to contrast with, and be significantly
*      different from, the base, highlight, shadow, and background color
*      scheme.  This is used for indicators such as found inside a selected
*      radio button or check box.
* </dl>
*/
--]]

local class = require "pl.class"

local FrameStyle = {
	Sunken = 0x01,
	Raised = 0x02
}

class.GUIStyle()


function GUIStyle.SetBaseColor(self, acolor)
	self.BaseColor = acolor;
	self.HighlightColor = ColorUtils.brighter(self.BaseColor);
	self.ShadowColor = ColorUtils.darker(self.BaseColor);
	self.Background = ColorUtils.brighter(self.HighlightColor);
	self.TextBackground = self.BaseColor;
end

function GUIStyle:_init()
	self.BorderWidth = 2;
	self.Padding = 2;

	self:SetBaseColor(Colors.LtGray)

	self.Foreground = Colors.LtGray;

	self.BottomShadow = ColorUtils.darker(self.Foreground);
	self.BottomShadowTopLiner = ColorUtils.brighter(self.BottomShadow);

	self.TopShadow = ColorUtils.brighter(self.Foreground);

	-- Calculated
	self.SunkenColor = self.Foreground;
	self.RaisedColor = self.Foreground;
end

function GUIStyle.DrawFrame(self, aPort, x, y, w, h, style)
	local n=0;

	if style == FrameStyle.Sunken then
		for n=0, self.BorderWidth-1 do
			aPort:SetStrokeColor(self.HighlightColor)
			aPort:DrawLine(x+n, y+h-n, x+w-n, y+h-n);    -- bottom shadow
			aPort:DrawLine(x + w - n, y + n, x + w - n, y + h);	    -- right shadow
		end

		for n=0, self.BorderWidth-1 do
			aPort:SetStrokeColor(self.ShadowColor)
			aPort:DrawLine(x+n, y+n, x+w-n, y+n);	    -- top edge
			aPort:DrawLine(x+n, y+n, x+n, y+h-n);	    -- left edge
		end
	elseif style == FrameStyle.Raised then
		for n=0, self.BorderWidth-1 do
			aPort:SetStrokeColor(self.ShadowColor)
			aPort:DrawLine(x+n, y+h-n, x+w-n, y+h-n);      -- bottom shadow
			aPort:DrawLine(x+w-n, y+n, x+w-n, y+h);	    -- right shadow
		end

		for n=0, self.BorderWidth-1 do
 			aPort:SetStrokeColor(self.HighlightColor)
			aPort:DrawLine(x + n, y + n, x + w - n, y + n);	    -- top edge
			aPort:DrawLine(x + n, y + n, x + n, y + h - n);	    -- left edge
		end
	end
end

function GUIStyle.DrawSunkenRect(self, aPort, x, y, w, h)
	aPort:SetStrokeColor(Colors.Transparent)
	aPort:SetFillColor(self.BaseColor)
	aPort:DrawRect(x, y, w, h);

	self:DrawFrame(aPort, x, y, w, h, FrameStyle.Sunken);
end

function GUIStyle.DrawRaisedRect(self, aPort, x, y, w, h)
	aPort:SetStrokeColor(Colors.Transparent)
	aPort:SetFillColor(self.BaseColor)
	aPort:DrawRect(x, y, w, h);

	self:DrawFrame(aPort, x, y, w, h, FrameStyle.Raised);
end


return GUIStyle
