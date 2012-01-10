--[[
	Processing Language skin

	From the Processing Reference: http://processing.org/reference/
--]]

require "imlua"
require "cdlua"
require "cdluaim"
require "iuplua"
require "iupluacd"

require "iupluagl"
require "luagl"
require "luaglu"

local socket = require "socket"		-- For clock ticks


--[[
require "BAppContext"

local appctx = BAppContext({
		Modules={
			".",
			"../UI",
			"../geometry",
			"../core",
		}
	})
--]]

-- Implementing a class structure
class = require "pl.class"


require "GUIStyle"
require "IMRenderer"
require "KeyboardActivityArgs"
require "MouseActivityArgs"
require "Constants"
require "Color"
require "Point3D"
require "Vector3D"
require "OrthoCamera"
require "Texture"

-- Language Skins
require "Shape"
require "Typography"
require "Image"
require "PImage"
require "Transform"
require "Environment"
require "Input"
require "Math"
require "glsl"	-- for 'mod'

-- Objects used in UI
require "GText"
require "param_superellipse"
require "Rectangle"



defaultguistyle = GUIStyle();


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

	-- Set it up the way we want it
	-- We must do this here, or we don't get
	-- alpha transparency
	gl.Enable(gl.BLEND);
	gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
	gl.Disable(gl.DEPTH_TEST);            -- Disables Depth Testing


	local canvas2D = cd.CreateCanvas(cd.IUP, self)
--assert(canvas2D ~= nil, "defaultcanvas.map_cb - cd canvas is nil")
	self.canvas2D = canvas2D
	canvas2D:Activate()
	canvas2D:YAxisMode(0)	-- Invert the y-axis
end

function defaultglcanvas.resize_cb(self, width, height)
	iup.GLMakeCurrent(self)

	Processing.ReSize(width, height)
end


-- Keyboard Activity
--[[
function KeyboardActivityArgs:_init(params)

	self.Keyboard = params.Keyboard;
	self.Window = params.Window;
	self.EventType = params.EventType;
	self.VirtualKeyCode = params.KeyCode;
	self.KeyMasks = params.KeyMasks;
	self.KeyChar = params.KeyChar;

	self.RepeatCount = params.RepeatCount or 0;
	self.OEMScanCode = params.OEMScanCode;
	self.IsExtended = params.Extended;
--]]
function defaultglcanvas:keypress_cb(c, press)
	print("Processing.lua.keypress_cb: ", c, press);
	local et = KeyActivityType.KeyDown
	if press == 0 then
		et = KeyActivityType.KeyUp
	end

	local ke = KeyboardActivityArgs{
		EventType = et,
		KeyChar = c,
	}

	Processing.KeyActivity(ke)

	return iup.DEFAULT
end

function defaultglcanvas:k_any(c)
	print("Processing.lua.key_any: ", c);

	return iup.CONTINUE
end

-- Mouse Activity
function defaultglcanvas.motion_cb(self, x, y, status)
	Processing.MouseMove(x, y, status);
end

-- Indicates mouse button activity, either pressed or released
function defaultglcanvas.button_cb(self, but, pressed, x, y, status)
	if pressed == 1 then
		Processing:MouseDown(but, x, y, status);
	else
		Processing:MouseUp(but, x, y, status);
	end
end

--[[

function defaultglcanvas.wheel_cb(self, delta, x, y, status)
	defaultviewer:Wheel(delta, x, y, status)
end

--]]


--defaultrenderer = GLRenderer:new()
defaultrenderer = IMRenderer(1920, 1080)

-- Initial Processing State
Processing = {
	Renderer = defaultrenderer,

	ColorMode = RGB,

	BackgroundColor = Color(127, 127, 127, 255),
	FillColor = Color(255,255,255,255),
	StrokeColor = Color(0,0,0,255),

	StrokeWeight = 1,

	Smooth = false,

	Running = false,
	FrameRate = 30,

	-- Typography
	TextSize = 12,
	TextAlignment = LEFT,
	TextYAlignment = BASELINE,
	TextLeading = 0,
	TextMode = SCREEN,
	TextSize = 12,
}


function Processing.SetColorMode(amode)
	local oldMode = Processing.ColorMode
	Processing.ColorMode = amode

	return oldMode
end

function Processing.SetSmooth(smoothing)
	local graphics = defaultrenderer
	Processing.Smooth = smoothing

	Processing.Renderer:SetAntiAlias(smoothing)
end

function Processing.SetBackgroundColor(acolor)
	Processing.Renderer:SetBackgroundColor(acolor)
	Processing.Renderer:Clear();

	return oldColor
end

function Processing.ClearCanvas()
	Processing.Renderer:Clear();
end

function Processing.SetFillColor(acolor)
	return Processing.Renderer:SetFillColor(acolor);
end

function Processing.SetStrokeColor(acolor)
	return Processing.Renderer:SetStrokeColor(acolor);
end

-- Drawing Primitives
function Processing.SetPointSize(ptSize)

	Processing.Renderer:SetPointSize(ptSize)
end

function Processing.SetLineCap(cap)
	Processing.Renderer:SetLineCap(cap)
end

function Processing.SetLineJoin(join)
	Processing.Renderer:SetLineJoin(join)
end

function Processing.SetStrokeWeight(weight)
	Processing.StrokeWeight = weight

	Processing.Renderer:SetLineWidth(weight)
end

function Processing.DrawPoint(x,y,z)
	z = z or 0

	Processing.Renderer:DrawPoint(x,y)
end

function Processing.DrawLine(startPt, endPt)
	Processing.Renderer:DrawLine(startPt[1], startPt[2],
		endPt[1], endPt[2])
end

function Processing.DrawPolygon(pts)
	Processing.Renderer:DrawPolygon(pts)
end

function Processing.DrawRect(x, y, w, h)
	Processing.Renderer:DrawRect(x, y, w, h)
end

function Processing.DrawTriangle(x1, y1, x2, y2, x3, y3)
	Processing.Renderer:DrawTriangle(x1, y1, x2, y2, x3, y3)
end

function Processing.DrawQuad(x1, y1, x2, y2, x3, y3, x4, y4)
	local pts = {
		Vector3D.new{x1, y1, 0},
		Vector3D.new{x2, y2, 0},
		Vector3D.new{x3, y3, 0},
		Vector3D.new{x4, y4, 0},
	}

	Processing.DrawPolygon(pts, true)
end

function Processing.DrawEllipse(centerx, centery, awidth, aheight)
	local steps = 30
	local pts = {}

	for i = 0, steps do
		local u = i/steps
		local angle = u * 2*PI
		local x = awidth/2 * cos(angle)
		local y = aheight/2 * sin(angle)
		local pt = Point3D.new(x+centerx, y+centery, 0)
		table.insert(pts, pt)
	end

	Processing.DrawPolygon(pts, true)
end

function Processing.DrawImage(tex, offsetx, offsety, awidth, aheight)
	offsetx = offsetx or 0
	offsety = offsety or 0
	awidth = awidth or tex.width
	aheight = aheight or tex.height

	-- Ideally, make it a texture map, and put it on a quad
	-- Render the quad
	tex:Render(offsetx, offsety, awidth, aheight)
end

--[=[
	TYPOGRAPHY
--]=]

function Processing.GetTextWidth(astring)
	return 0
end

function Processing.DrawText(x, y, txt)
	Processing.Renderer:DrawText(x, y, txt)
end

function Processing.SetFontName(fontname)
	Processing.Renderer:SetFont(fontname);
end

function Processing.SetTextAlignment(align, yalign)
	Processing.Renderer:SetTextAlignment(align)
end

--[==============================[
	TRANSFORMATION
--]==============================]

function Processing.Translate(x, y, z)
	z = z or 0

	local graphics = defaultrenderer
	graphics:Translate({x,y,z})
end

function Processing.Rotate(x,y,z)
	local graphics = defaultrenderer
	graphics:Rotate({degrees(x),degrees(y),degrees(z)})

	local canvas2D = defaultglcanvas.canvas2D
	canvas2D:TransformRotate(degrees(z))
end

function Processing.PushMatrix()
	gl.PushMatrix();
end

function Processing.PopMatrix()
	gl.PopMatrix();
end

--[==============================[
	Compiling
--]==============================]

function Processing.ApplyState()
	Processing.Renderer:ApplyAttributes();
	Processing.SetSmooth(Processing.Smooth)
end

function Processing.ClearGlobalFunctions()
	-- Clear out the global routines
	-- That the user may have supplied
	_G.setup = nil
	_G.draw = nil
	_G.keyPressed = nil
	_G.mousePressed = nil

	-- Reset Transformation matrices
	local canvas2D = defaultglcanvas.canvas2D
	canvas2D:Transform(nil)

end

function Processing.Compile(inputtext)
	iup.GLMakeCurrent(defaultglcanvas);

	Processing.Renderer:loadPixels()

	-- Apply State before compiling
	-- new code
	Processing.ApplyState()

	-- Set the camera position
	OrthoCamera.Render()

	Processing.ClearGlobalFunctions();
	Processing.Renderer:Clear();

	-- Compile the code
	local f = loadstring(inputtext)
	f()

	if _G.setup ~= nil then
		--print("User Defined setup()")
		_G.setup()
	end

	-- Update pixels and draw to screen
	Processing.Renderer:updatePixels()
	Processing.Renderer:Render(0,0)

	-- Run animation loop
	Processing.StartAnimation()
end

function Processing.StartAnimation()
	-- How many milliseconds per frame
	local secondsperframe = 1 / Processing.FrameRate
	local status = iup.DEFAULT
	local startTime = socket.gettime()		-- startMillis
	local nextTime = startTime + secondsperframe
	local tolerance = 0.001
	local currentTime = startTime

	Processing.Running = true;
	frameCount = 0
	repeat
		-- update seconds per frame
		-- in case it changes during the animation
		--secondsperframe = 1 / Processing.FrameRate

		-- If we don't do this, then UI will never
		-- get a chance to do anything
		status = iup.LoopStep()

		if ((status == iup.CLOSE) or (not Processing.Running)) then
			--print(status)
			break
		end

		currentTime = socket.gettime()
		if currentTime < nextTime then
			-- do nothing but perhaps wait
			--local diff = nextTime - currentTime
			--if diff < tolerance then
			--end
		else
			Processing.Tick()
			frameCount = frameCount + 1
			nextTime = nextTime + secondsperframe

			-- Update pixels and draw to screen
			-- Draw the pixels to the screen
			Processing.Renderer:updatePixels()
			Processing.Renderer:Render(0,0)
		end
	until status == iup.CLOSE

	--print("Processing.StartAnimation - END")
end

function Processing.StopAnimation()
	Processing.Running = false
end

function Processing.Tick()
	iup.GLMakeCurrent(defaultglcanvas);

	-- Render the camera so we can
	-- reset the modelview matrix
	-- This will need to change we we
	-- want to change the camera position for 3D
	OrthoCamera.Render()


	if (_G.draw) ~= nil then
		draw()
	end

	-- Call to action directly
	--defaultglcanvas:action()

	--iup.Update(defaultglcanvas);	-- will cause action() to be called
	gl.Flush();
	gl.Finish();

	-- if double buffered
	-- swap buffers in the end
	--iup.GLSwapBuffers(self);
	pmouseX = mouseX
	pmouseY = mouseY
end

function Processing.ReSize(awidth, aheight)
	if aheight == 0 then           -- Calculate The Aspect Ratio Of The Window
		aheight = 1
	end

	gl.Viewport(0, 0, awidth, aheight)

	local canvas2D = defaultglcanvas.canvas2D
	if canvas2D ~= nil then
		canvas2D:Activate()
	end

	OrthoCamera.SetSize(awidth, aheight)

	iup.Update(defaultglcanvas);	-- will cause action() to be called
end

function Processing.SetCanvasSize(awidth, aheight, MODE)
	width = awidth;
	height = aheight;

	--OrthoCamera.SetSize(awidth, aheight)
end

--[==============================[
	Keyboard ACTIVITY
--]==============================]
-- A key has been pressed
--	local ke = KeyboardActivityArgs{
function Processing.KeyActivity(ke)
	local ke = KeyboardActivityArgs{
		EventType = et,
		KeyChar = c,
	}
	-- If the user has implemented
	-- keyPressed()
	-- call that function
	if (_G.keyPressed) ~= nil then
		keyPressed(ke)
	end
end


--[==============================[
	MOUSE ACTIVITY
--]==============================]

function Processing.MouseMove(x, y, status)
	mouseX = x
	mouseY = y
end

function Processing.MouseDown(but, x, y, status)
	isMousePressed = true;
	if (_G.mousePressed) ~= nil then
		mousePressed()
	end
end

function Processing.MouseUp(but, x, y, status)
	isMousePressed = false;
end

--[[
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
--]]
