--
-- FabuWindow.lua
--
-- The primary window for BanateCAD
--
-- Copyright (c) 2011  William Adams
--

require "iuplua"

require "MenuManager"
require "MenuController"
require "Layout"

local class = require "pl.class"
class.BWindow()

function BWindow:_init(o)
	o = o or {}		-- create object if user does not provide one

	self.Name = o.Name or "Application"
	self.menuman = MenuManager()
	self.Window = iup.dialog({
		-- The primary content
		viewinsplit;

		-- Initial attributes of window
		--size='HALFxHALF',
		RASTERSIZE = "1024x768",
		TITLE=o.Name,
		SHRINK="YES",
		})

	self.menucontrol = MenuController({window=self})
	self.Window.MENU = self.menuman:GetMainMenu(self.menucontrol)
end

function BWindow.Show(self)
	self.Window:show();
end

function BWindow.SetFilename(self,filename)
	local name = filename or "File"

	self.Window.TITLE = self.Name..' - '..name;
end

function BWindow.close_cb(self)
print("BWindow.close_cb")
	return iup.CLOSE
end

function BWindow.show_cb(self, state)
print("BWindow.show_cb: ",state)
end

function BWindow.Run(self)
	self:Show()

	local status = iup.DEFAULT
	repeat
		status = iup.LoopStep()

		if (status == iup.CLOSE) then
		--print(status)
			iup.ExitLoop()
		end
		--print(status)
	until status == iup.CLOSE
end

return BWindow
