require ("CADVM")

Scene = {}
function Scene:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	o.commands = o.commands or {}

	return o
end


function Scene.clear(self)
	self.commands = {}
end

function Scene.appendCommand(self, aCommand)
	table.insert(self.commands, aCommand)
end

function Scene.clearcachedobjects()
	appendCommand(CADVM.clearcachedobjects())
end

--[[
	In order to support animation, we need to inform
	the shapes of the passage of time.  We do that by
	iterating through the list of shapes, calling their
	Update methods.
--]]
function Scene.Update(self, count)
print("Scene.Update: ", count)
	for i, cmd in ipairs(self.commands) do
		if cmd.command == CADVM.SHAPE then
			if (cmd.value.Update ~= nil) then
				cmd.value:Update(count);
			end
		end
	end
end

defaultscene = Scene:new()
