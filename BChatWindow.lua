--
-- FabuWindow.lua
--
-- The primary window for BanateCAD
--
-- Copyright (c) 2011  William Adams
--

require ("iuplua")


intext = iup.text({
	expand = 'YES',
	MULTILINE = 'NO',
	TABSIZE = "4",
	WORDWRAP = "YES",
	FONTFACE = "MS Shell Dlg 2",
	FONTSIZE = 12,
	})

-- Capture keyboard commands
function intext.k_any(self, c)
	if iup.K_CR == c then
		outconsole.APPEND = intext.VALUE
		intext.VALUE = ''
	end
end



outconsole = iup.text({
	expand = 'YES',
	MULTILINE = 'YES',
	TABSIZE = "4",
	WORDWRAP = "YES",
	FONTFACE = "MS Shell Dlg 2",
	FONTSIZE = 12,
	})

viewinsplit = iup.split({
	outconsole,
	intext;
	orientation = "HORIZONTAL",
	showgrip = "FALSE",
	VALUE = "800",
})


BChatWindow = {}
function BChatWindow:new(o)
	o = o or {}		-- create object if user does not provide one

	setmetatable(o, self)
	self.__index = self

	o.Name = o.Name or "Banate Chat"
	o.window = iup.dialog({
		-- The primary content
		viewinsplit;

		-- Initial attributes of window
		--size='HALFxHALF',
		RASTERSIZE = "1024x768",
		TITLE=o.Name,
		})

	--o.menucontrol = MenuController:new({window=o})
	--o.window.MENU = o.menuman:GetMainMenu(o.menucontrol)

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

function BChatWindow.Show(self)
	self.window:show();
end

function BChatWindow.SetFilename(self,filename)
	local name = filename or "File"

	self.window.TITLE = self.Name..' - '..name;
end




