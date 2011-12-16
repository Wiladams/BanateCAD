--
-- BApplication.lua
--
-- The generic application object
-- Copyright (c) 2011  William Adams
--

require ("iuplua")
require ("BAppContext")

BGameApplication={}

function BGameApplication:new(o)
	o = o or {}		-- create object if user does not provide one

	setmetatable(o, self)
	self.__index = self

	o.Name = o.Name or "Application"

	o.AppContext = o.AppContext or BAppContext:new({Modules={"core"},})

	return o
end


function BGameApplication.Run(self)
	iup.key_open();

	self.Window:Show();

	--self.Window:Run()

	--iup.ExitLoop()
	iup.MainLoop()
end
