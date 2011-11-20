--
-- FabuWindow.lua
--
-- The primary window for BanateCAD
--
-- Copyright (c) 2011  William Adams
--

require ("iuplua")

require ('MenuManager')
require ("MenuController")
require ("Layout")

FabuWindow = {}
function FabuWindow:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	o.menuman = MenuManager:new()
	o.window = iup.dialog({
		-- The primary content
		--mainsplit;
		viewinsplit;

		-- Initial attributes of window
		--size='HALFxHALF',
		RASTERSIZE = "1024x768",
		TITLE="Fabu CAD",
		})

	return o
end

function FabuWindow.Run(self)
	-- turn on keyboard input
	iup.key_open();

	self.menucontrol = MenuController:new({window=self})
	self.window.MENU = self.menuman:GetMainMenu(self.menucontrol)
	self.window:show();

	iup.MainLoop()
end

function FabuWindow.SetTitle(self, title)
	self.window.TITLE = title;
end

