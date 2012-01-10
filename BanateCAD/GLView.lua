--
-- GLView.lua
--
-- Copyright (c) 2011  William Adams
--
-- GL View handler for BanateCAD
--

require ("iuplua")
require ("iupluagl")
require ("luagl")
require ("luaglu")

local class = require "pl.class"

class.GLView()

function GLView:_init(o)
	o = o or {}		-- create object if user does not provide one

	self.Canvas = iup.glcanvas({
		BUFFER = "DOUBLE",
		EXPAND = "YES",
		RASTERSIZE = "320x240",
		DEPTH_SIZE = "16"
		});
end

--[[
function GLView.Canvas.action(self)
	iup.GLMakeCurrent(self);

	defaultviewer:DisplayScene(defaultscene);

	-- double buffered
	-- so swap buffers in the end
	iup.GLSwapBuffers(self);
	gl.Flush();
end


function GLView.Canvas.map_cb(self)
	defaultviewer:SetCanvas(self)
end

function GLView.Canvas.k_any(self, c)
	iup.GLMakeCurrent(self);

	defaultviewer:KeyPress(c);

	iup.Update(self)
end


function GLView.Canvas.resize_cb(self, width, height)
	iup.GLMakeCurrent(self)
	defaultviewer:SetSize(width, height)
	iup.Update(self)
end



function GLView.Canvas.wheel_cb(self, delta, x, y, status)
	defaultviewer:Wheel(delta, x, y, status)
end

-- Indicates mouse button activity, either pressed or released
function GLView.Canvas.button_cb(self, but, pressed, x, y, status)
	if pressed == 1 then
		defaultviewer:MouseDown(but, x, y, status);
	else
		defaultviewer:MouseUp(but, x, y, status);
	end
end

-- Mouse movement
function GLView.Canvas.motion_cb(self, x, y, status)
	defaultviewer:MouseMove(x, y, status);
end
--]]





















