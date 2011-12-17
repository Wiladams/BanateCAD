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

--
-- Construct the default GL Canvas

defaultglcanvas = iup.glcanvas({
		BUFFER = "SINGLE",
		EXPAND = "YES",
		RASTERSIZE = "1024x768",
		--DEPTH_SIZE = "16"
		});



function defaultglcanvas.action(self)
	iup.GLMakeCurrent(self);

	if (_G.draw) ~= nil then
		draw()
	end

	gl.Flush();

	-- double buffered
	-- so swap buffers in the end
	--iup.GLSwapBuffers(self);
end


function defaultglcanvas.map_cb(self)
	iup.GLMakeCurrent(self);

end

function defaultglcanvas.resize_cb(self, width, height)
	iup.GLMakeCurrent(self)
	Processing.SetSize(width, height)

	iup.Update(self)
end

--[[
function defaultglcanvas.k_any(self, c)
	iup.GLMakeCurrent(self);

	defaultviewer:KeyPress(c);

	iup.Update(self)
end

function defaultglcanvas.wheel_cb(self, delta, x, y, status)
	defaultviewer:Wheel(delta, x, y, status)
end

-- Indicates mouse button activity, either pressed or released
function defaultglcanvas.button_cb(self, but, pressed, x, y, status)
	if pressed == 1 then
		defaultviewer:MouseDown(but, x, y, status);
	else
		defaultviewer:MouseUp(but, x, y, status);
	end
end

-- Mouse movement
function defaultglcanvas.motion_cb(self, x, y, status)
	defaultviewer:MouseMove(x, y, status);
end
--]]


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





