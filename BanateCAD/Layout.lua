--
-- Layout.lua
--
-- The layout for BanateCAD
-- Copyright (c) 2011  William Adams
--

require "iuplua"
require "SceneViewer"
--
-- Construct the default GL Canvas

defaultglcanvas = iup.glcanvas({
		BUFFER = "DOUBLE",
		EXPAND = "YES",
		RASTERSIZE = "320x240",
		DEPTH_SIZE = "16"});


function defaultglcanvas.setup(self)
	iup.GLMakeCurrent(self);

	defaultviewer:DisplayScene(defaultscene);

	--setup()

	-- double buffered
	-- so swap buffers in the end
	iup.GLSwapBuffers(self);
	gl.Flush();
end

function defaultglcanvas.action(self)
	iup.GLMakeCurrent(self);

	defaultviewer:DisplayScene(defaultscene);

	-- double buffered
	-- so swap buffers in the end
	iup.GLSwapBuffers(self);
	gl.Flush();
end


function defaultglcanvas.map_cb(self)
	iup.GLMakeCurrent(self);

	defaultviewer:SetCanvas(self)
end

function defaultglcanvas.k_any(self, c)
	iup.GLMakeCurrent(self);

	defaultviewer:KeyPress(c);

	iup.Update(self)
end


function defaultglcanvas.resize_cb(self, width, height)
	iup.GLMakeCurrent(self)
	defaultviewer:SetSize(width, height)
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


defaultviewer:SetCanvas(defaultglcanvas);



intext = iup.text({
	expand = 'YES',
	MULTILINE = 'YES',
	TABSIZE = "4",
	WORDWRAP = "YES",
	FONTFACE = "MS Shell Dlg 2",
	FONTSIZE = 8,
	})

outconsole = iup.canvas({
	EXPAND = "YES"
	})

--
viewinsplit = iup.split({
	defaultglcanvas,
	intext;
	orientation = "HORIZONTAL",
	showgrip = "FALSE",
	VALUE = "800",
})

--[[
outsplit = iup.split({
	defaultglcanvas,
	outconsole;
	orientation = "HORIZONTAL",
	showgrip = "FALSE",
	VALUE = "800",
})

mainsplit = iup.split({
	intext,
	outsplit;
	color = "192 192 192",
	orientation = "VERTICAL",
	showgrip = "FALSE",
	VALUE = "300",
})
--]]
