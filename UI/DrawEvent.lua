
local class = require "pl.class"

-- <summary>
-- This class represents the information needed by graphics to paint when necessary.
-- </summary>
class.DrawEvent()

function DrawEvent:_init(renderer, clipRect)
	self.ClipRect = clipRect;
	self.GraphPort = renderer;
end

return DrawEvent
