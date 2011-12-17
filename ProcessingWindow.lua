--
-- FabuWindow.lua
--
-- The primary window for BanateCAD
--
-- Copyright (c) 2011  William Adams
--

-- Global namespace


require "iuplua"
require "iupluagl"
require "luagl"
require "luaglu"


intext = iup.text({
	expand = 'YES',
	MULTILINE = 'YES',
	TABSIZE = "4",
	WORDWRAP = "YES",
	FONTFACE = "MS Shell Dlg 2",
	FONTSIZE = 8,
	})

viewinsplit = iup.split({
	defaultglcanvas,
	intext;
	orientation = "HORIZONTAL",
	showgrip = "FALSE",
	VALUE = "800",
})


ProcessingWindow = {}
function ProcessingWindow:new(o)
	o = o or {}		-- create object if user does not provide one

	setmetatable(o, self)
	self.__index = self

	o.Name = o.Name or "Application"
	o.menuman = MenuManager:new()
	o.window = iup.dialog({
			viewinsplit;	-- The primary content

			-- Initial attributes of window
			--size='HALFxHALF',
			RASTERSIZE = "1024x768",
			TITLE=o.Name,
			SHRINK= "YES",
		})

	o.menucontrol = MenuController:new({window=o})
	o.window.MENU = o.menuman:GetMainMenu(o.menucontrol)

--print("ProcessingWindow.new() - END")
	return o
end

function ProcessingWindow.Show(self)
	self.window:show();
end

function ProcessingWindow.SetFilename(self,filename)
	local name = filename or "File"

	self.window.TITLE = self.Name..' - '..name;
end

function ProcessingWindow.k_any(self, c)
print("ProcessingWindow.k_any: ", c)
	return iup.CONTINUE;
end



