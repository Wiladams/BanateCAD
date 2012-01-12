--
-- BWindow.lua
--
-- The primary window for HeadsUp
--
-- Copyright (c) 2011  William Adams
--

require "iuplua"

require "MenuManager"
require "MenuController"
require "FileManager"
require "SceneViewer"
require "defaultglcanvas"
require "Scene"
require "SceneBuilder"

local class = require "pl.class"

--[[
defaultviewer = SceneViewer({
		colorscheme = colorschemes.Cornfield;
		wireframe = true;
		orthomode = true;
		viewer_distance = 500;
		obj_rot = {35, 0, -25};
		obj_trans = {0, 0, 0};
		showaxes = true;
		showcrosshairs = false;
		mouse_drag_active = false;
		Renderer = SceneRenderer();
		PrimaryAxesGraphic = PrimaryAxes:new();
		AxesBugGraphic = AxesBug:new();
		});
--]]

defaultfilemanager = FileManager();
defaultscene = Scene()
defaultviewer = SceneViewer()

defaultviewer:SetCanvas(defaultglcanvas);


-- The layout for the window
intext = iup.text({
	expand = 'YES',
	MULTILINE = 'YES',
	TABSIZE = "4",
	WORDWRAP = "YES",
	FONTFACE = "MS Shell Dlg 2",
	FONTSIZE = 8,
	})

--
viewinsplit = iup.split({
	defaultglcanvas,
	intext;
	orientation = "HORIZONTAL",
	showgrip = "FALSE",
	VALUE = "800",
})





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

	self.menucontrol = MenuController({Window=self})
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
