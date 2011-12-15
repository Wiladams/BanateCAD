-- This is a template
-- In order to create a functor:
-- 1) Copy this code
-- 2) Change the Moniker: 'Functor' to the name of
--		Whatever functor is being created
-- 3) Implement the specific code in the Execute() function
--

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


