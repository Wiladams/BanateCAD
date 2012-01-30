-- Actor.lua

local class = require "pl.class"

class.Actor()

--[[
{
	WorldFrame = {0,0,0},
	Boundary = {0,0,0},
}
--]]

function Actor:_init(params)
	params = params or {}
	if params.Origin and params.Extent then
		self.Frame = Rectangle(params.Origin, params.Extent)
	elseif params.Frame then
		self.Frame = params.Frame
	else
		self.Frame = Rectangle()
	end

	self.Visible = params.Visible or true;
    self.Active = params.Active or true;
    self.Enabled = params.Enabled or false;

	self.MouseCatcher = params.MouseCatcher;
	self.KeyboardCatcher = params.KeyboardCatcher;
end

-- To be seen
function Actor:Render(graphPort)
end

-- To Act
function Actor:Update(tickCount)
end

-- To React
function Actor:SetMouseCatcher(catcher)
	self.MouseCatcher = catcher;
end

function Actor:SetKeyboardCatcher(catcher)
	self.KeyboardCatcher = catcher;
end

function Actor:MouseActivity(ma)
	if self.MouseCatcher then
		self.MouseCatcher(self, ma)
	end
end

function Actor:KeyboardActivity(ka)
	if self.KeyboardCatcher then
		self.KeyboardCatcher(self, ka)
	end
end

-- Inquiry
function Actor:GetBoundary()
end

function Actor:GetFrame()
end

function Actor:Contains(pt)
end

