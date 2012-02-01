require ("CADVM")

local class = require "pl.class"

class.Scene()


function Scene:_init(params)
	params = params or {}		-- create object if user does not provide one

	self.commands = params.commands or {}
end


function Scene.clear(self)
	self.commands = {}
end

function Scene.appendCommand(self, aCommand)
	table.insert(self.commands, aCommand)
end

function Scene.clearcachedobjects(self)
	self:appendCommand(CADVM.clearcachedobjects())
end

--[[
	In order to support animation, we need to inform
	the shapes of the passage of time.  We do that by
	iterating through the list of shapes, calling their
	Update methods.
--]]
function Scene.Update(self, tickCount)
	-- Now tell all the objects to update themselves
	for i, cmd in ipairs(self.commands) do
		if cmd.command == CADVM.SHAPE then
			if (cmd.value.Update ~= nil) then
				cmd.value:Update(tickCount);
--print("Scene.Update")
			end
		end
	end
end

