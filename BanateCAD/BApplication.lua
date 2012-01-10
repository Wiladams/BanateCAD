--
-- BApplication.lua
--
-- The generic application object
-- Copyright (c) 2011  William Adams
--

require ("iuplua")
require ("BAppContext")

local class = require "pl.class"
class.BApplication()

function BApplication:_init(o)
	o = o or {}		-- create object if user does not provide one

	self.Name = o.Name or "Application"

	self.AppContext = o.AppContext or BAppContext({Modules={"core"},})
	self.Window = o.Window
end


function BApplication.Run(self)
	iup.key_open();

	self.Window:Show();

	iup.MainLoop()
end
