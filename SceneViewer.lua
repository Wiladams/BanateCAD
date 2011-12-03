--
-- SceneViewer.wlua
--
-- Viewer and manipulator of 3D scenes
-- Copyright (c) 2011  William Adams
--

require ("iuplua")
require ("iupluagl")
require ("luagl")
require ("luaglu")

require ("BLight")
require ("BLighting")
require ("colorschemes")
--require ("maths")

require ("Renderer")
require ("PrimaryAxes")
require ("AxesBug")
require ("SceneBuilder")
require ("GLView")

FARAWAY = 100000;

-- Lighting
light = true

SceneViewer = {}
function SceneViewer:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	o.Lighting = o.Lighting or BLighting:new({
		Lights = {
			BLight:new({
				ID = gl.LIGHT0,
				Diffuse = {1,1,1,1},
				Position = {-2,-2,2,0},
				Enabled = true
			}),
			BLight:new({
				ID = gl.LIGHT1,
				Diffuse = {1,1,1,1},
				Position = {1,1,-1,0},
				Enabled = true
			})
		}
		})

	return o
end


function SceneViewer.SetCanvas(self, canvas)
	glcanvas = canvas;

	iup.GLMakeCurrent(glcanvas)

	gl.Enable(gl.BLEND);
	gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);

	gl.Enable(gl.DEPTH_TEST);            -- Enables Depth Testing
	gl.DepthRange(-FARAWAY, FARAWAY);
end

--
-- Do the work necessary to properly configure and place
-- the 'camera' in the scene.
--
function SceneViewer.SetupOrtho(self, distance, offset)

	gl.MatrixMode(gl.PROJECTION);
	gl.LoadIdentity()

	if (offset) then
		gl.Translate(-0.8, -0.8, 0);
	end

	local l = distance/ 10;

	gl.Ortho(-self.w_h_ratio*l, self.w_h_ratio*l, -(1/self.w_h_ratio)*l, (1/self.w_h_ratio)*l,-FARAWAY, FARAWAY);
end

--==============================================
-- Positioning Camera
--==============================================

function SceneViewer.SetViewBack(self)
	self.obj_trans = {90,0,180};
	iup.Update(glcanvas);
end

function SceneViewer.SetViewBottom(self)
	self.obj_trans = {180,0,0};
	iup.Update(glcanvas);
end

function SceneViewer.SetViewCenter(self)
	self.obj_trans = {0,0,0};
	iup.Update(glcanvas);
end

function SceneViewer.SetViewDiagonal(self)
	self.obj_trans = {55,0,25};
	iup.Update(glcanvas);
end

function SceneViewer.SetViewFront(self)
	self.obj_rot = {90, 0, 0}
	iup.Update(glcanvas);
end

function SceneViewer.SetViewLeft(self)
	self.obj_rot = {90, 0, 270}
	iup.Update(glcanvas);
end

function SceneViewer.SetViewRight(self)
	self.obj_rot = {90, 0, 90}
	iup.Update(glcanvas);
end

function SceneViewer.SetViewTop(self)
	self.obj_rot = {0, 0, 0}
	iup.Update(glcanvas);
end

function SceneViewer.PositionCamera(self)
	-- First setup the orthographic projection
	if (self.orthomode) then
		self:SetupOrtho(self.viewer_distance, false)
	end

	-- Now setup for the lookat
	gl.MatrixMode("MODELVIEW")
	gl.LoadIdentity()

	--campos = defaultcamera:GetPosition()
	--glu.LookAt(campos[1],campos[2], campos[3],		-- position
	--	defaultcamera.look[1], defaultcamera.look[2], defaultcamera.look[3],	-- look at
	--	0, 0, 1)							-- up vector
	glu.LookAt(0, -self.viewer_distance, 0,	-- position
		0,0,0,							-- look at
		0, 0, 1)						-- up vector

	-- Adjust for rotation
	gl.Rotate(self.obj_rot[1], 1.0, 0.0, 0.0);
	gl.Rotate(self.obj_rot[2], 0.0, 1.0, 0.0);
	gl.Rotate(self.obj_rot[3], 0.0, 0.0, 1.0);

	-- Adjust for translation
	gl.Translate(self.obj_trans[1], self.obj_trans[2],self.obj_trans[3]);
end

--==============================================
--
--==============================================

function SceneViewer.ToggleAxesDisplay(self)
	self.showaxes = not self.showaxes;
	iup.Update(glcanvas);
end

function SceneViewer.ClearCachedObjects(self)
	self.Renderer:ClearCachedObjects();
end

function SceneViewer.DisplayBackground(self, renderer)
	self.Renderer:ClearCanvas(self.colorscheme.BACKGROUND_COLOR)
end

function SceneViewer.DisplayScene(self, scene)
	gl.ColorMaterial(gl.FRONT_AND_BACK, gl.AMBIENT_AND_DIFFUSE)
	gl.Enable(gl.COLOR_MATERIAL)

	self.Lighting:Render()
	self:PositionCamera();


	gl.DepthFunc(gl.LESS);
	gl.CullFace(gl.BACK);
	--gl.Disable(gl.CULL_FACE);

	self.Renderer:ClearCanvas(self.colorscheme.BACKGROUND_COLOR)
	self:DisplayBackground()

	if (self.showaxes) then
		self.PrimaryAxesGraphic:Draw();
		--self.AxesBugGraphic:Draw();
	end

	self:PositionCamera();
	self.Renderer:DisplayScene(scene);

	if (self.showaxes) then
		self.AxesBugGraphic:Draw();
	end
end

function SceneViewer.SetSize(self, width, height)

	if height == 0 then           -- Calculate The Aspect Ratio Of The Window
		height = 1
	end

	self.w_h_ratio = math.sqrt(width/height);

	gl.Viewport(0, 0, width, height)
end

function SceneViewer.SetViewerDistance(self, distance)
	self.viewer_distance = distance;
	self.PrimaryAxesGraphic:SetViewerDistance(distance);

	iup.Update(glcanvas)
end



--===================================================
--	MOUSE ACTIVITY
--===================================================
--[[
iup.isshift(status)
iup.iscontrol(status)
iup.isbutton1(status)
iup.isbutton2(status)
iup.isbutton3(status)
iup.isbutton4(status)
iup.isbutton5(status)
iup.isdouble(status)
iup.isalt(status)
iup.issys(status)
--]]



function normalizeAngles(angles)
	angles[1] = normalizeAngle(angles[1])
	angles[2] = normalizeAngle(angles[2])
	angles[3] = normalizeAngle(angles[3])

	return angles;
end

function SceneViewer.Wheel(self, delta, x, y, status)
	self:SetViewerDistance(self.viewer_distance * math.pow(0.9, delta));
end

function SceneViewer.MouseDown(self, button, x, y, status)
	self.mouse_drag_active = true;
	self.last_mouse = {["x"] = x, ["y"] = y}
	--grabMouse();
	--setFocus();
end

function SceneViewer.MouseUp(self, button, x, y, status)
	self.mouse_drag_active = false;
	--releaseMouse();
end

function SceneViewer.MouseMove(self, x, y, status)
	local this_mouse = {["x"] = x, ["y"] = y}

	if self.mouse_drag_active then
	local dx = x - self.last_mouse.x;
	local dy = y - self.last_mouse.y;

	-- If left mouse button, then change the rotation
		if iup.isbutton1(status) then
			self.obj_rot[1] = self.obj_rot[1] + dy;
			if iup.isshift(status) then
				self.obj_rot[2] = self.obj_rot[2] + dx;
			else
				self.obj_rot[3] = self.obj_rot[3] + dx;
			end

			-- Normalize the angle to be in the 0 - 360 range
			self.obj_rot = normalizeAngles(self.obj_rot);
		end

		-- The right mouse can serve dual purpose
		-- When the shift key is held, it is the same as having
		-- a scroll wheel.
		-- Without the shift key, we simply translate
		if iup.isbutton3(status) then
			if iup.isshift(status) then
				self:SetViewerDistance(self.viewer_distance + dy);
			else
				self.obj_trans[1] = self.obj_trans[1] + dx;
				self.obj_trans[3] = self.obj_trans[3] - dy;
			end
		end

		iup.Update(glcanvas)
	end

	self.last_mouse = this_mouse;
end

--===================================================
--	KEYBOARD ACTIVITY
--===================================================
function SceneViewer.KeyPress(self, c)
  if c == iup.K_q or c == iup.K_ESC then
    return iup.CLOSE
  end

	if c == iup.K_F6 then
		do_compile_and_render()
	end


	-- Moving Camera Position
	-- Zoom in and out
	if c == iup.K_plus then
		self:SetViewerDistance(self.viewer_distance * 0.9);
	elseif c == iup.K_minus then
		self:SetViewerDistance(self.viewer_distance / 0.9);
	end

	-- Rotate
	if c == iup.K_RIGHT then
		self.obj_rot[3] = self.obj_rot[3] + 10;
	elseif c == iup.K_LEFT then
		self.obj_rot[3] = self.obj_rot[3] - 10;
	elseif c == iup.K_UP then -- around x axis
		self.obj_rot[1] = self.obj_rot[1] - 6;
	elseif c == iup.K_DOWN then
		self.obj_rot[1] = self.obj_rot[1] + 6;
	end
end


defaultviewer = SceneViewer:new({
		colorscheme = colorschemes.Cornfield;
		wireframe = true;
		orthomode = true;
		viewer_distance = 500;
		obj_rot = {35, 0, -25};
		obj_trans = {0, 0, 0};
		showaxes = true;
		showcrosshairs = false;
		mouse_drag_active = false;
		Renderer = Renderer:new();
		PrimaryAxesGraphic = PrimaryAxes:new();
		AxesBugGraphic = AxesBug:new();
		});


defaultviewer:SetCanvas(defaultglcanvas);















