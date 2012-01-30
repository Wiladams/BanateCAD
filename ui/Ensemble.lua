-- Ensemble.lua
local class = require "pl.class"
require "Actor"

class.Ensemble(Actor)

function Ensemble:_init(params)
	self:super(params)

	self.Members = {}
	if params.Members then
		self:AddMembers(params.Members)
	end
end

function Ensemble:AddMembers(members)
	for _,member in ipairs(members) do
		self:AddMember(member);
	end
end

function Ensemble:AddMember(member)
	if member then
		-- Assume the new member has dimensions specified relative
		-- to our frame.  So, offset their boundary by our WorldFrame
		-- origin
		member.Frame:Offset(self.Frame.Origin[1], self.Frame.Origin[2])

		-- Expand our world frame to recognize the new member
		self.Frame = self.Frame:Union(member.Frame);

		-- Expand bouding frame

		-- Add the member to the ensemble
		table.insert(self.Members, member);
	end
end

-- Visualizing
function Ensemble:RenderBackground(graphPort)
end

function Ensemble:RenderMembers(graphPort)
	for _,member in ipairs(self.Members) do
		member:Render(graphPort)
	end
end

function Ensemble:RenderForeground(graphPort)
end

function Ensemble:Render(graphPort)
	self:RenderBackground(graphPort)
	self:RenderMembers(graph)
	self:RenderForeground(graphPort)
end

-- To Act
function Ensemble:Update(tickCount)
	for _,member in ipairs(self.Members) do
		if member.Update then
			member:Update(tickCount)
		end
	end
end

-- To React
function Ensemble:MouseActivity(ma)
	if not self.WorldFrame:Contains(ma.X, ma.Y) then
		return
	end

	for _,member in ipairs(self.Members) do
		if member.MouseActivity then
			member:MouseActivity(ma)
		end
	end

end

function Ensemble:KeyboardActivity(ka)
end
