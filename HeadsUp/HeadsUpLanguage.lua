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

class = require "pl.class"

require "maths"
require "glsl"	-- for 'mod'
require "Color"
require "Point3D"
require "Vector3D"


require "GUIStyle"
require "IMRenderer"
require "KeyboardActivityArgs"
require "MouseActivityArgs"
require "OrthoCamera"
require "Texture"

require "PImage"

-- Objects used in UI
require "Layout"
require "GBracket"
require "GFont"
require "GRoundedRectangle"
require "GText"
require "param_superellipse"
require "Rectangle"
require "ShapeBuilder"



-- Constants

HALF_PI = math.pi / 2
PI = math.pi
QUARTER_PI = math.pi/4
TWO_PI = math.pi * 2

-- Constants related to colors
RGB = 1
HSB = 2


-- for beginShape()
POINTS = gl.POINTS
LINES = gl.LINES
TRIANGLES = gl.TRIANGLES
TRIANGLE_STRIP = gl.TRIANGLE_STRIP
TRIANGLE_FAN = gl.TRIANGLE_FAN
QUADS = gl.QUADS
QUAD_STRIP = gl.QUAD_STRIP

CLOSE = 1

LEFT = 1
CENTER = 2
RIGHT = 4

TOP = 8
BOTTOM = 16
BASELINE = 32

MODEL = 1
SCREEN = 2
SHAPE = 3

--defaultrenderer = GLRenderer:new()
--local canvas_width = 1920
--local canvas_height = 1080
local canvas_width = 1024
local canvas_height = 768

width = 1024
height = 768

focused = false
frameCount = 0
--frameRate = 0
online = false
screen = nil
width = 1024
height = 768

-- Mouse State information
-- These are changed live
mouseButton = false
isMousePressed = false

-- Mouse position during current frame
mouseX = 0
mouseY = 0

-- Mouse position from previous frame
pmouseX = 0
pmouseY = 0


key = 0
keyCode = 0


defaultguistyle = GUIStyle();



-- Create the default message queue
defaultuiqueue = AsyncQueue()


require "defaultglcanvas"

defaultcanvas = defaultglcanvas;

defaultrenderer = IMRenderer(canvas_width, canvas_height)


-- Initial Processing State
Processing = {
	Camera = OrthoCamera(),
	Renderer = defaultrenderer,

	ColorMode = RGB,

	BackgroundColor = Color(127, 127, 127, 255),
	FillColor = Color(255,255,255,255),
	StrokeColor = Color(0,0,0,255),

	Running = false,
	FrameRate = 20,

	-- Typography
	TextSize = 12,
	TextAlignment = LEFT,
	TextYAlignment = BASELINE,
	TextLeading = 0,
	TextMode = SCREEN,
	TextSize = 12,

	Graphics = {},
	Actors = {},
	Interactors = {},
	MouseInteractors = {},
	KeyboardInteractors = {},
}

function Processing.ClearCanvas()
	Processing.Renderer:Clear();
end

function Processing.SetBackgroundColor(acolor)
	Processing.Renderer:SetBackgroundColor(acolor)
	Processing.Renderer:Clear();

	return oldColor
end


--[==============================[
	Compiling
--]==============================]

function Processing.ApplyState()
	Processing.Renderer:ApplyAttributes();
end

function Processing.ClearGlobalFunctions()
	Processing.Actors = {}
	Processing.Graphics = {}
	Processing.Interactors = {}
	Processing.MouseInteractors = {}
	Processing.KeyboardInteractors = {}

	-- Clear out the global routines
	-- That the user may have supplied
	_G.setup = nil
	_G.draw = nil
	_G.keyPressed = nil
	_G.mousePressed = nil
end

function Processing.Compile(inputtext)
	iup.GLMakeCurrent(defaultglcanvas);

	-- Create a new renderer
	-- destroy old renderer explicitly

	-- create new renderer
	defaultrenderer = IMRenderer(canvas_width, canvas_height)
	Processing.Renderer = defaultrenderer;

	Processing.Renderer:loadPixels();

	-- Apply State before compiling
	-- new code
	Processing.ApplyState()

	-- Set the camera position
	Processing.Camera:Render()

	Processing.ClearGlobalFunctions();
	Processing.Renderer:ResetTransform();
	Processing.Renderer:Clear();

	-- Compile the code
	local f = loadstring(inputtext)
	f()

	if _G.setup ~= nil then
		_G.setup()
	end

	-- Update pixels and draw to screen
	Processing.Renderer:updatePixels()
	Processing.Renderer:Render(defaultcanvas, 0,0)

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
	local ellapsedTime = 0;

	Processing.Running = true;
	Processing.TickCount = 0
	Processing.FramesPerSecond = 0

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
		ellapsedTime = currentTime - startTime
		if currentTime < nextTime then
			-- do nothing but perhaps wait
			--local diff = nextTime - currentTime
			--if diff < tolerance then
			--end
		else
			Processing.TickCount = Processing.TickCount + 1
			frameCount = frameCount + 1
			Processing.FramesPerSecond = Processing.TickCount / ellapsedTime
			Processing.Tick(Processing.TickCount)
			nextTime = nextTime + secondsperframe

		end
	until status == iup.CLOSE

	--print("Processing.StartAnimation - END")
end

function Processing.StopAnimation()
	Processing.Running = false
end

function Processing.Tick(tickCount)
	iup.GLMakeCurrent(defaultglcanvas);

	-- Render the camera so we can
	-- reset the modelview matrix
	-- This will need to change we we
	-- want to change the camera position for 3D
	Processing.Camera:Render()

	-- Draw the immediate graphics
	if (_G.draw) ~= nil then
		draw()
	end

	-- Update all the actors
	for _,actor in ipairs(Processing.Actors) do
		actor:Update(Processing.TickCount)
	end


	-- Draw all the retained graphics
	for _,graphic in ipairs(Processing.Graphics) do
		graphic:Render(Processing.Renderer)
	end


	-- if double buffered
	-- swap buffers in the end
	--iup.GLSwapBuffers(self);

	-- Track current mouse position
	pmouseX = mouseX
	pmouseY = mouseY

	-- Update pixels and draw to screen
	-- Draw the pixels to the screen
	Processing.Renderer:updatePixels()
	Processing.Renderer:Render(defaultglcanvas, 0,0)

	gl.Flush();
	gl.Finish();
end

function Processing.ReSize(awidth, aheight)
	if aheight == 0 then
		aheight = 1
	end

	gl.Viewport(0, 0, awidth, aheight)

--[[
	local canvas2D = defaultglcanvas.canvas2D
	if canvas2D ~= nil then
		canvas2D:Activate()
	end
--]]

	Processing.Camera:SetSize(awidth, aheight)

	iup.Update(defaultglcanvas);	-- will cause action() to be called
end

function Processing.SetCanvasSize(awidth, aheight, MODE)
--print("Processing.SetCanvasSize: ", awidth, aheight)
	width = awidth;
	height = aheight;
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

	for _,kinteractor in ipairs(Processing.KeyboardInteractors) do
		kinteractor:KeyboardActivity(ke)
	end
end


--[==============================[
	MOUSE ACTIVITY
--]==============================]

function Processing.MouseActivity(ma)
	if ma.ActivityType == MouseActivityType.MouseDown then
		Processing.MouseDown(ma.Button, ma.X, ma.Y, ma.KeyFlags)
	elseif ma.ActivityType == MouseActivityType.MouseUp then
		Processing.MouseUp(ma.Button, ma.X, ma.Y, ma.KeyFlags)
	elseif ma.ActivityType == MouseActivityType.MouseMove then
		Processing.MouseMove(ma.X, ma.Y, ma.KeyFlags)
	elseif ma.ActivityType == MouseActivityType.MouseWheel then
		Processing.MouseWheel(ma.Delta, ma.X, ma.Y, ma.KeyFlags)
	end

	for _,minteractor in ipairs(Processing.MouseInteractors) do
		minteractor:MouseActivity(ma);
	end
end

function Processing.MouseMove(x, y, status)
	--x, y = Processing.Renderer.canvas:wWorld2Canvas(x, y)
--print("Processing.MouseMove: ", x, y, status)
	mouseX = x
	mouseY = y
end

function Processing.MouseDown(but, x, y, status)
	--x, y = Processing.Renderer.canvas:wWorld2Canvas(x, y)

	isMousePressed = true;
	if (_G.mousePressed) ~= nil then
		mousePressed()
	end
end

function Processing.MouseUp(but, x, y, status)
	isMousePressed = false;
end

function Processing.MouseWheel(delta, x, y, status)
end







--[==================================================[
		LANGUAGE COMMANDS
--]==================================================]

function blue(c)
	return c.B
end

function green(c)
	return c.G
end

function red(c)
	return c.R
end

function alpha(c)
	return c.A
end


function color(...)
	return Color(unpack(arg))
end

function background(...)
	if arg.n == 1 and type(arg[1]) == "table" then
		return Processing.SetBackgroundColor(arg[1])
	end

	local acolor = Color(unpack(arg))
--print("background: ", acolor[1], acolor[2], acolor[3], acolor[4])
	return Processing.SetBackgroundColor(acolor)
end

function colorMode(amode)
	-- if it's not valid input, just return
	if amode ~= RGB and amode ~= HSB then return end

	--return Processing.SetColorMode(amode)
end

function fill(...)
	-- See if we're being passed a 'Color'
	-- type
	if arg.n == 1 and type(arg[1]) == "table" then
		return Processing.Renderer:SetFillColor(arg[1])
		--return Processing.SetFillColor(arg[1])
	end

	local acolor = Color(unpack(arg))

	return Processing.Renderer:SetFillColor(acolor)
end

function noFill()
	local acolor = Color(0,0)

	return Processing.Renderer:SetFillColor(acolor)
end

function noStroke(...)
	local acolor = Color(0,0)

	return Processing.Renderer:SetStrokeColor(acolor)

	--return Processing.SetStrokeColor(acolor)
end

function stroke(...)
	if arg.n == 1 and type(arg[1]) == "table" then
		-- We already have a color structure
		-- so just set it
		return Processing.Renderer:SetStrokeColor(arg[1])
	end

	-- Otherwise, construct a new color object
	-- and set it
	local acolor = color(unpack(arg))

	return Processing.Renderer:SetStrokeColor(acolor)
end


function point(x,y,z)
	--y = Processing.Renderer.height - y

	Processing.Renderer:DrawPoint(x,y)
end

function line(...)
	-- We either have 4, or 6 parameters
	local x1, y1, z1, x2, y2, z2

	if arg.n == 4 then
		x1 = arg[1]
		y1 = arg[2]
		x2 = arg[3]
		y2 = arg[4]
	elseif arg.n == 6 then
		x1 = arg[1]
		y1 = arg[2]
		z1 = arg[3]
		x2 = arg[4]
		y2 = arg[5]
		z2 = arg[6]
	end

	Processing.Renderer:DrawLine(x1, y1, x2, y2)
end

function rect(x, y, w, h)
	Processing.Renderer:DrawRect(x, y, w, h)
end

function triangle(x1, y1, x2, y2, x3, y3)
	Processing.Renderer:DrawTriangle(x1, y1, x2, y2, x3, y3)
end

function polygon(pts)
	Processing.Renderer:DrawPolygon(pts)
end

function quad(x1, y1, x2, y2, x3, y3, x4, y4)
	local pts = {
		Point3D(x1, y1, 0),
		Point3D(x2, y2, 0),
		Point3D(x3, y3, 0),
		Point3D(x4, y4, 0),
	}

	polygon(pts)
end

function ellipse(centerx, centery, awidth, aheight)
	local steps = 30
	local pts = {}

	for i = 0, steps do
		local u = i/steps
		local angle = u * 2*PI
		local x = awidth/2 * cos(angle)
		local y = aheight/2 * sin(angle)
		local pt = Point3D(x+centerx, y+centery, 0)
		table.insert(pts, pt)
	end

	polygon(pts)
end

--[====================================[
--	Curves
--]====================================]



function bezier(x1, y1,  x2, y2,  x3, y3,  x4, y4)
	Processing.Renderer:DrawBezier(
		{x1, y1, 0},
		{x2, y2, 0},
		{x3, y3, 0},
		{x4, y4, 0})
end

function bezierDetail(...)
end

function bezierPoint(...)
end

-- Catmull - Rom curve
function curve(x1, y1,  x2, y2,  x3, y3,  x4, y4)
	Processing.Renderer:DrawCurve(
		{x1, y1, 0},
		{x2, y2, 0},
		{x3, y3, 0},
		{x4, y4, 0})
end

function curveDetail(...)
end

function curvePoint(...)
end

function curveTangent(...)

end

function curveTightness(...)
end

-- ATTRIBUTES
function smooth()
	Processing.Renderer:SetAntiAlias(true)
end

function noSmooth()
	Processing.Renderer:SetAntiAlias(false)
end

function pointSize(ptSize)
	Processing.Renderer:SetPointSize(ptSize)
end

function strokeCap(cap)
	Processing.Renderer:SetLineCap(cap);
end

function strokeJoin(join)
	Processing.Renderer:SetLineJoin(join)
end

function strokeWeight(weight)
	Processing.Renderer:SetLineWidth(weight)
end

function size(awidth, aheight, MODE)
	Processing.SetCanvasSize(awidth, aheight, MODE)
end

-- VERTEX
function beginShape(...)
	local sMode = POLYGON
	if arg.n == 0 then
		Processing.VertexMode = gl.POLYGON
	elseif arg[1] == POINTS then
		Processing.ShapeMode = gl.POINTS
	elseif arg[1] == LINES then
		Processing.ShapeMode = gl.LINES
	end
end

function bezierVertex()
end

function curveVertex()
end

function endShape()
end

function texture()
end

function textureMode()
end

function vertex(...)
	local x = nil
	local y = nil
	local z = nil
	local u = nil
	local v = nil

	if (arg.n == 2) then
		x = arg[1]
		y = arg[2]
		z = 0
	elseif arg.n == 3 then
		x = arg[1]
		y = arg[2]
		z = arg[3]
	elseif arg.n == 4 then
		x = arg[1]
		y = arg[2]
		u = arg[3]
		v = arg[4]
	elseif arg.n == 5 then
		x = arg[1]
		y = arg[2]
		z = arg[3]
		u = arg[4]
		v = arg[5]
	end


	if u and v then
		-- texture coordinate
	end

	if x and y and z then
		gl.vertex(x,y,z)
	end

end






--[==============================[
	TRANSFORM
--]==============================]

-- Matrix Stack
function popMatrix()
	Processing.Renderer:PopMatrix();
end


function pushMatrix()
	Processing.Renderer:PushMatrix();
end

function applyMatrix()
end

function resetMatrix()
end

function printMatrix()
end


-- Simple transforms
function translate(x, y, z)
	Processing.Renderer:Translate(x, y, z)
end

function rotate(rads)
	Processing.Renderer:Rotate(rads)
end

function rotateX(rad)
end

function rotateY(rad)
end

function rotateZ(rad)
end

function scale(sx, sy, sz)
	Processing.Renderer:Scale(sx, sy, sz)
end

function shearX()
end

function shearY()
end



--[[
	Scene
--]]
function addactor(actor)
	if not actor then return end

	if actor.Update then
		table.insert(Processing.Actors, actor)
	end

	if actor.Render then
		addgraphic(actor)
	end

	addinteractor(actor)
end

function addgraphic(agraphic)
	if not agraphic then return end

	table.insert(Processing.Graphics, agraphic)
end

function addinteractor(interactor)
	if not interactor then return end

	if interactor.MouseActivity then
		table.insert(Processing.MouseInteractors, interactor)
	end

	if interactor.KeyboardActivity then
		table.insert(Processing.KeyboardInteractors, interactor)
	end
end


--[==============================[
	TYPOGRAPHY
--]==============================]

function createFont()
end

function loadFont()
end

function text(x, y, txt)
	--Processing.Renderer:Scale(1, -1)
	Processing.Renderer:DrawText(x, y, txt)
	--Processing.Renderer:Scale(1, -1)
end

-- Attributes

function textAlign(align, yalign)
	yalign = yalign or Processing.TextYAlignment

	Processing.TextAlignment = align
	Processing.TextYAlignment = yalign
	--Processing.SetTextAlignment(align, yalign)

	Processing.Renderer:SetTextAlignment(align)
end

function textLeading(leading)
	Processing.TextLeading = leading
end

function textMode(mode)
	Processing.TextMode = mode
end

function textSize(asize)
	Processing.TextSize = asize
end

function textWidth(txt)
	twidth, theight = Processing.Renderer:MeasureString(txt)
	return Processing.GetTextWidth(astring)
end

function textFont(fontname)
	return Processing.Renderer:SetFont(fontname);
	--return Processing.SetFontName(fontname)
end

-- Metrics
--[[
function textAscent()
end

function textDescent()
end
--]]

--[==============================[
	ENVIRONMENT
--]==============================]

function cursor()
end

function noCursor()
end

function frameRate(rate)
	Processing.FrameRate = rate
end




--[==============================[
	IMAGE
--]==============================]
function createImage(awidth, aheight, dtype)
	local pm = PImage(awidth, aheight, dtype)
	return pm
end

-- Loading and Displaying
--(img, offsetx, offsety, awidth, aheight)
function image(img, x, y, awidth, aheight)
	if img == nil then return end
	awidth = awidth or 0
	aheight = aheight or 0

	Processing.Renderer:DrawImage(img, x, y, awidth, aheight)
end

function imageMode()
end

function loadImage(filename)
	local pm = PImage({Filename = filename})

	return pm
end

function requestImage()
end

function tint()
end

function noTint()
end

-- Pixels
function blend()
end

function copy()
end

function filter()
end

function get(x, y)
	return Processing.Renderer:get(x,y)
end

function set(x, y, acolor)
	Processing.Renderer:set(x, y, acolor)
end

function loadPixels()
	Processing.Renderer:loadPixels()
end

function pixels()
end

function updatePixels()
	Processing.Renderer:updatePixels();
end



