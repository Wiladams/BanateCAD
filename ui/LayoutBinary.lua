local class = require "pl.class"

require "Layout"
require "LayoutManager"

class.BinaryLayout(LayoutManager)

function BinaryLayout:_init(aPos, gap)
	self:super()
	self.PrimaryGraphic = null;
	self.SecondaryGraphic = null;
	self.Margin = gap;
	self.Position = aPos;
end

function BinaryLayout.ResetLayout(self)
	self.PrimaryGraphic = nil;
	self.SecondaryGraphic = nil;
end

function BinaryLayout.AddToLayout(self, g)
	if (self.SecondaryGraphic == nil) then
		if (self.PrimaryGraphic == nil)
			self.PrimaryGraphic = g;
		else
			self.SecondaryGraphic = g;
		end

		-- If we still don't have a secondary graphic,
		-- then just return without doing anything.
		if (self.SecondaryGraphic == nil) then
			return ;
		end

		local frame = self.PrimaryGraphic.Frame;

		local left = frame.Left;
		local right = frame.Right;
		local top = frame.Top;
		local bottom = frame.Bottom;
		local midx = (right - left + 1) / 2;
		local midy = (bottom - top + 1) / 2;
		local graphicwidth = self.SecondaryGraphic.Frame.Width;
		local graphicheight = self.SecondaryGraphic.Frame.Height;
		local xpos = 0;
		local ypos = 0;

		if self.Position == Position.Center then
			xpos = midx-graphicwidth/2;
			ypos = midy-graphicheight/2;
		elseif self.Position == Position.Left
			xpos = left - graphicwidth - fMargin;
			ypos = midy-graphicheight/2;
		elseif self.Position ==  Position.Top:
			xpos = midx-graphicwidth/2;
			ypos = top - graphicheight - fMargin;
		elseif self.Position ==  Position.Right:
			xpos = right + fMargin;
			ypos = midy-graphicheight/2;
		elseif self.Position ==  Position.Bottom:
			xpos = midx-graphicwidth/2;
			ypos = bottom + fMargin;
		elseif self.Position ==  Position.TopLeft:
			xpos = left - graphicwidth - fMargin;
			ypos = top - graphicheight - fMargin;
		elseif self.Position ==  Position.TopRight:
			xpos = right + fMargin;
			ypos = top - graphicheight - fMargin;
		elseif self.Position ==  Position.BottomLeft:
			xpos = left - graphicwidth - fMargin;
			ypos = bottom + fMargin;
		elseif self.Position ==  Position.BottomRight:
			xpos = right + fMargin;
			ypos = bottom + fMargin;
		end

		-- Move the secondary graphic to its new position
		self.SecondaryGraphic.MoveTo(xpos, ypos);
    end
end
