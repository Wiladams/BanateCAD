--[[
	Processing Language skin

	From the Processing Reference: http://processing.org/reference/
--]]

require ("iuplua")
require ("iupluagl")
require ("luagl")
require ("luaglu")

--
-- Construct the default GL Canvas

defaultglcanvas = iup.glcanvas({
		BUFFER = "SINGLE",
		EXPAND = "YES",
		--RASTERSIZE = "1024x768",
		--DEPTH_SIZE = "16"
		});



function defaultglcanvas.action(self)
	iup.GLMakeCurrent(self);

	if (_G.draw) ~= nil then
		draw()
	end

	gl.Flush();

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


defaultrenderer = GLRenderer:new()

Processing = {
	ColorMode = RGB,
	BackgroundColor = {0.5, 0.5, 0.5, 1},
	FillColor = {1, 1, 1, 1},
	StrokeColor = {0, 0, 0, 1},
	Smooth = false,
}


function Processing.SetColorMode(amode)
	local oldMode = Processing.ColorMode
	Processing.ColorMode = amode

	return oldMode
end

function Processing.SetSmooth(smoothing)
	local graphics = defaultrenderer
	Processing.Smooth = smoothing

	graphics:SetAntiAlias(smoothing)
end

function Processing.SetBackgroundColor(acolor)
	local graphics = defaultrenderer

	local oldColor = Processing.BackgroundColor
	Processing.BackgroundColor = acolor

	graphics:ClearCanvas(Processing.BackgroundColor)

	return oldColor
end

function Processing.SetFillColor(acolor)
	local oldColor = Processing.FillColor
	Processing.FillColor = acolor
	defaultrenderer.FillColor = Processing.FillColor

	return oldColor
end

function Processing.SetStrokeColor(acolor)
	local oldColor = Processing.StrokeColor
	Processing.StrokeColor = acolor
	defaultrenderer.StrokeColor = Processing.StrokeColor

	return oldColor
end

-- Drawing Primitives
function Processing.SetPointSize(ptSize)
	local graphics = defaultrenderer
	graphics:SetPointSize(ptSize)
end

function Processing.SetStrokeWeight(weight)
	local graphics = defaultrenderer
	graphics:SetLineWidth(weight)
end

function Processing.DrawPoint(x,y,z)
	local graphics = defaultrenderer
	z = z or 0

	local pt = Vector3D.new(x, y, z)
	graphics:DrawPoint(pt)
end

function Processing.DrawLine(startPoint, endPoint)
	local graphics = defaultrenderer

	graphics:DrawLine({startPoint, endPoint, 1})
end

function Processing.DrawRect(x, y, width, height)
	local graphics = defaultrenderer

	local pts = {
		Vector3D.new{x, y, 0},
		Vector3D.new{x, y+height, 0},
		Vector3D.new{x+width, y+height, 0},
		Vector3D.new{x+width, y, 0},
	}

	graphics:DrawPolygon(pts);

end

function Processing.DrawTriangle(x1, y1, x2, y2, x3, y3)
	local graphics = defaultrenderer
	local pts = {
		Vector3D.new{x1, y1, 0},
		Vector3D.new{x3, y3, 0},
		Vector3D.new{x2, y2, 0},
	}

	graphics:DrawPolygon(pts);
end

function Processing.DrawQuad(x1, y1, x2, y2, x3, y3, x4, y4)
	local graphics = defaultrenderer
	local pts = {
		Vector3D.new{x1, y1, 0},
		Vector3D.new{x2, y2, 0},
		Vector3D.new{x3, y3, 0},
		Vector3D.new{x4, y4, 0},
	}

	graphics:DrawPolygon(pts);
end


function Processing.ApplyState()
	Processing.SetBackgroundColor(Processing.BackgroundColor)
	Processing.SetFillColor(Processing.FillColor)
	Processing.SetStrokeColor(Processing.StrokeColor)
	Processing.SetSmooth(Processing.Smooth)
end

function Processing.Compile(inputtext)
	iup.GLMakeCurrent(defaultglcanvas);

	local graphics = defaultrenderer


	-- Apply State before compiling
	-- new code
	Processing.ApplyState()

	-- Set the camera position
	OrthoCamera.Render()

	-- Clear out setup() and draw()
	_G.setup = nil
	_G.draw = nil


	-- Compile the code
	local f = loadstring(inputtext)
	f()

	if _G.setup ~= nil then
		print("User Defined setup()")
		_G.setup()
	end

end

function Processing.Tick()
	iup.GLMakeCurrent(defaultglcanvas);

	if (_G.draw) ~= nil then
		draw()
	end

--	iup.Update(defaultglcanvas);	-- will cause action() to be called
	gl.Flush();
	-- if double buffered
	-- swap buffers in the end
	--iup.GLSwapBuffers(self);
end

function Processing.SetSize(width, height)
	if height == 0 then           -- Calculate The Aspect Ratio Of The Window
		height = 1
	end

	OrthoCamera.SetSize(width, height)
end

function Processing.SetCanvasSize(awidth, aheight, MODE)
	width = awidth;
	height = aheight;

	--OrthoCamera.SetSize(width, height)
end


-- Setup Animation Timer
function createTimer(frequency)
	aTimer = iup.timer({time=1000/frequency})

	return aTimer
end

defaultFrequency = 20
defaultTimer = createTimer(defaultFrequency)
function defaultTimer.action_cb(self)
	Processing.Tick()
end
