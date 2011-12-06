-- This is a pattern
-- It should be copied, and the Execute
-- and .new functions should be changed to
-- specific
Functor={}
Functor_mt = {}

function Functor.new(...)
	local new_inst = {}

	setmetatable(new_inst, Functor_mt)

	return new_inst
end

function Functor.Execute(self, ...)
	print ("Functor.Execute")
end

Functor_mt.__call = Functor.Execute;


--[[
local aCommand = Functor.new("this")

aCommand()
--]]


