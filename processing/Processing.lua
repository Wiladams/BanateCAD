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

local socket = require "socket"

-- Implementing a class structure
class = require "pl.class"



-- Initial Processing State
Processing = {
	ColorMode = RGB,

	BackgroundColor = color(127, 255),
	FillColor = color(255),
	StrokeColor = color(0),

	StrokeWeight = 1,

	Smooth = false,

	Running = false,
	FrameRate = 30
}

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

--	if self.canvas2D == nil then
--		local canvas2D = cd.CreateCanvas(cd.IUP, self)
--		self.canvas2D = canvas2D
--		canvas2D:Activate()
--		canvas2D:YAxisMode(0)	-- Invert the y-axis
--		Processing.ApplyState()
--	end

	Processing.ReSize(width, height)
end


-- Keyboard Activity
function defaultglcanvas.keypress_cb(c, press)
	Processing.KeyActivity(c, press)

	return iup.DEFAULT
end

--function defaultglcanvas.k_any(self, c)
--	Processing.KeyActivity(c);
--end

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


defaultrenderer = GLRenderer:new()


--function RGBColor(acolor)
--	local rgb = {acolor[1]*255, acolor[2]*255, acolor[3]*255, acolor[4]*255}
--	return rgb;
--end

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
	local oldColor = Processing.BackgroundColor
	Processing.BackgroundColor = acolor

	--local r,g,b,a = rgba(acolor)
	--Processing.BackgroundColorRGB = cd.EncodeColor(r, g, b)
	--Processing.BackgroundColorRGBA = cd.EncodeAlpha(Processing.BackgroundColorRGB, a)

	Processing.ClearCanvas()

	return oldColor
end

function Processing.ClearCanvas()
	local graphics = defaultrenderer

	local norm = Processing.BackgroundColor:Normalized();
	--print(Processing.BackgroundColor)
	graphics:ClearCanvas(norm)

	--local canvas2D = defaultglcanvas.canvas2D
	--canvas2D:SetBackground(Processing.BackgroundColorRGBA)
	--canvas2D:Clear()
end

function Processing.SetFillColor(acolor)
	local oldColor = Processing.FillColor

	Processing.FillColor = acolor
	defaultrenderer.FillColor = acolor:Normalized()

	--local rgb = RGBColor(acolor)
	--Processing.FillColorRGB = cd.EncodeColor(rgb[1], rgb[2], rgb[3])
	--Processing.FillColorRGBA = cd.EncodeAlpha(Processing.FillColorRGB, rgb[4])


	--local canvas2D = defaultglcanvas.canvas2D
	--canvas2D:Foreground(Processing.FillColorRGBA)

	return oldColor
end

function Processing.SetStrokeColor(acolor)
	local oldColor = Processing.StrokeColor
	Processing.StrokeColor = acolor
	defaultrenderer.StrokeColor = acolor:Normalized(acolor)

	--local rgb = RGBColor(acolor)
	--Processing.StrokeColorRGB = cd.EncodeColor(rgb[1], rgb[2], rgb[3])
	--Processing.StrokeColorRGBA = cd.EncodeAlpha(Processing.StrokeColorRGB, rgb[4])


	--local canvas2D = defaultglcanvas.canvas2D
	--canvas2D:Foreground(Processing.FillColorRGBA)

	return oldColor
end

-- Drawing Primitives
function Processing.SetPointSize(ptSize)
	local graphics = defaultrenderer
	graphics:SetPointSize(ptSize)
end

function Processing.SetStrokeWeight(weight)
	Processing.StrokeWeight = weight
	local graphics = defaultrenderer
	graphics:SetLineWidth(weight)

	--local canvas2D = defaultglcanvas.canvas2D
	--canvas2D:LineWidth(weight)
end

function Processing.DrawPoint(x,y,z)
	z = z or 0

	local pt = Point3D.new(x, y, z)
	local graphics = defaultrenderer
	graphics:DrawPoint(pt)

	--local canvas2D = defaultglcanvas.canvas2D
	--canvas2D:Pixel(x, y, Processing.StrokeColorRGBA)
end

function Processing.DrawPolygon(pts, use3D)
	use3D = use3D or false

	if (use3D) then
		local graphics = defaultrenderer

		graphics:DrawPolygon(pts, RenderMode.SOLID);

		graphics:DrawPolygon(pts, RenderMode.LOOP);

		return
	end

	local canvas2D = defaultglcanvas.canvas2D

	-- First do the solid portion using
	-- the fill color
	if Processing.FillColor[4] ~= 0 then
		canvas2D:Foreground(Processing.FillColorRGBA)
		canvas2D:Begin(cd.FILL)
		for _,pt in ipairs(pts) do
			canvas2D:Vertex(pt[1], pt[2])
		end
		canvas2D:End()
	end

	-- Then do it again with the stroke Color
	if Processing.StrokeColor[4] ~= 0 then
		canvas2D:Foreground(Processing.StrokeColorRGBA)
		canvas2D:Begin(cd.CLOSED_LINES)
		for _,pt in ipairs(pts) do
			canvas2D:Vertex(pt[1], pt[2])
		end
		canvas2D:End()
	end
end

function Processing.DrawLine(startPoint, endPoint)

	--local canvas2D = defaultglcanvas.canvas2D
	--canvas2D:Foreground(Processing.StrokeColorRGBA)
	--canvas2D:Line(
	--	startPoint[1], startPoint[2],
	--	endPoint[1], endPoint[2]
	--	)

	local graphics = defaultrenderer
	graphics:DrawLine({startPoint, endPoint, Processing.StrokeWeight}, Processing.StrokeWeight)
end


function Processing.DrawRect(x, y, width, height)

	local pts = {
		Vector3D.new{x, y, 0},
		Vector3D.new{x, y+height, 0},
		Vector3D.new{x+width, y+height, 0},
		Vector3D.new{x+width, y, 0},
	}

	Processing.DrawPolygon(pts, true)
end

function Processing.DrawTriangle(x1, y1, x2, y2, x3, y3)
	local pts = {
		Vector3D.new{x1, y1, 0},
		Vector3D.new{x3, y3, 0},
		Vector3D.new{x2, y2, 0},
	}

	Processing.DrawPolygon(pts, true)

end

function Processing.DrawQuad(x1, y1, x2, y2, x3, y3, x4, y4)
	local graphics = defaultrenderer
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

function Processing.DrawTexture(tex, offsetx, offsety, awidth, aheight)
	offsetx = offsetx or 0
	offsety = offsety or 0
	awidth = awidth or tex.width
	aheight = aheight or tex.height

	-- Ideally, make it a texture map, and put it on a quad
	-- Render the quad
	tex:Render(offsetx, offsety, awidth, aheight)
end

function Processing.DrawImage(img, offsetx, offsety, awidth, aheight)
	local canvas2D = defaultglcanvas.canvas2D

	--canvas2D:PutImageRectRGB(img.GLData, offsetx, offsety, img.width, img.height, 0, 0, 0, 0)
    --canvas2D:Flush()

	-- This works, but can't control transparency
	-- y-coordinates are flipped
	img.Bitmap:cdCanvasPutImageRect(canvas2D, offsetx, offsety, img.width, img.height, 0, 0, 0, 0)
    canvas2D:Flush()

	-- This will work, but y-coordinates are flipped
	--img:Render(defaultglcanvas)


--[[
	-- Disable blending, until we figure out the
	-- proper blending function
	gl.Disable(gl.BLEND);

	-- This is the absolute slowest this routine
	-- could be.  Going pixel by pixel, reconstructing
	-- color values along the way.

	-- TODO - use the image as a texture map on a quad
	-- and display the quad.  This should make it very
	-- fast as well as give the ability to stretch and
	-- shrink easily
	for row = 0, img.height-1 do
		for column = 0, img.width-1 do
			local r,g,b,a = img:get(column, row)
			stroke(r,g,b)
			point(x+column, y+row)
		end
	end

	gl.Enable(gl.BLEND);
--]]
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
	Processing.SetBackgroundColor(Processing.BackgroundColor)
	Processing.SetFillColor(Processing.FillColor)
	Processing.SetStrokeColor(Processing.StrokeColor)
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

	local graphics = defaultrenderer


	-- Apply State before compiling
	-- new code
	Processing.ApplyState()

	-- Set the camera position
	OrthoCamera.Render()

	Processing.ClearGlobalFunctions();

	-- Compile the code
	local f = loadstring(inputtext)
	f()

	if _G.setup ~= nil then
		--print("User Defined setup()")
		_G.setup()
	end

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
function Processing.KeyActivity(c)
	-- If the user has implemented
	-- keyPressed()
	-- call that function
	if (_G.keyPressed) ~= nil then
		keyPressed()
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
