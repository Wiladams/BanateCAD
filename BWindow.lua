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


BWindow = {}
function BWindow:new(o)
	o = o or {}		-- create object if user does not provide one

	setmetatable(o, self)
	self.__index = self

	o.Name = o.Name or "Application"
	o.menuman = MenuManager:new()
	o.window = iup.dialog({
		-- The primary content
		--mainsplit;
		viewinsplit;

		-- Initial attributes of window
		--size='HALFxHALF',
		RASTERSIZE = "1024x768",
		TITLE=o.Name,
		})

	o.menucontrol = MenuController:new({window=o})
	o.window.MENU = o.menuman:GetMainMenu(o.menucontrol)

	return o
end

--[[
function BWindow.Run(self)
	-- turn on keyboard input
	iup.key_open();

	self.window:show();

	iup.MainLoop()
end
--]]

function BWindow.Show(self)
	self.window:show();
end

function BWindow.SetFilename(self,filename)
	local name = filename or "File"

	self.window.TITLE = self.Name..' - '..name;
end
