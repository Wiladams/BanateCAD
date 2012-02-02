-- Actor.lua

local class = require "pl.class"

class.Actor()

--[[
{
	Origin = {0,0},
	Extent = {0,0},
}
--]]

function Actor:_init(params)
	params = params or {}

	self.Name = params.Name;

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

	self.Members = {}
	if params.Members then
		self:AddMembers(params.Members)
	end
end

function Actor:SetActive(active)
	self.Visible = active
	self.Active = active
	self.Enabled = active
end

-- Sizing
function Actor:Offset(dx, dy)
	self.Frame:Offset(dx, dy);
	self:OnTopologyChanged();
end

function Actor:SetFrame(origin, extent)
	self.Frame = Rectangle(origin, extent)
	self:OnTopologyChanged()
end

function Actor:OnTopologyChanged()
end

function Actor:AddMembers(members)
	for _,member in ipairs(members) do
		self:AddMember(member);
	end
end

function Actor:AddMember(member)
	if member then
		-- Assume the new member has dimensions specified relative
		-- to our frame.  So, offset their boundary by our WorldFrame
		-- origin
		member:Offset(self.Frame.Origin[1], self.Frame.Origin[2])
		--member.Frame:Offset(self.Frame.Origin[1], self.Frame.Origin[2])

		-- Expand our world frame to recognize the new member
		self.Frame = self.Frame:Union(member.Frame);

		-- Expand bouding frame

		-- Add the member to the ensemble
		table.insert(self.Members, member);
	end
end

-- To be seen
function Actor:RenderBackground(graphPort)
end

function Actor:RenderMembers(graphPort)
	for _,member in ipairs(self.Members) do
		member:Render(graphPort)
	end
end

function Actor:RenderSelf(graphPort)
end

function Actor:Render(graphPort)
	if not self.Visible then return end

	self:RenderBackground(graphPort)
	self:RenderMembers(graphPort)
	self:RenderSelf(graphPort)
end

-- To Act
function Actor:UpdateSelf(tickCount)
end

function Actor:UpdateMembers(tickCount)
	for _,member in ipairs(self.Members) do
		if member.Update then
			member:Update(tickCount)
		end
	end
end

function Actor:Update(tickCount)
	self:UpdateSelf(tickCount);
	self:UpdateMembers(tickCount);
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

	for _,member in ipairs(self.Members) do
		if member.MouseActivity then
			member:MouseActivity(ma)
		end
	end
end


function Actor:KeyboardActivity(ka)
	if self.KeyboardCatcher then
		self.KeyboardCatcher(self, ka)
	end
end

-- Inquiry


function Actor:GetFrame()
end

function Actor:Contains(x, y)
--print(string.format("Actor:Contains(%d, %d)", x, y))
--print(self.Frame)
	return self.Frame:Contains(x, y)
end

