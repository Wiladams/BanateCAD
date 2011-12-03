--
-- BApplication.lua
--
-- The generic application object
-- Copyright (c) 2011  William Adams
--

require ("iuplua")
require ("BAppContext")

BApplication={}

function BApplication:new(o)
	o = o or {}		-- create object if user does not provide one

	setmetatable(o, self)
	self.__index = self

	o.Name = o.Name or "Application"

	local mods = {
		Modules={"core"},
		}

	o.AppContext = o.AppContext or BAppContext:new(mods)

	return o
end


function BApplication.Run(self)
	iup.key_open();

	self.Window:Show();

	iup.MainLoop()
end
