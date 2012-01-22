require "maths"

--[[
function blue(c)
	local b = band(c, 0xff)
	return b
end

function green(c)
	local g = band(rshift(c, 8), 0xff)
	return g
end

function red(c)
	local r = band(rshift(c, 16), 0xff)
	return r
end

function alpha(c)
	local a = band(rshift(c, 24), 0xff)
	return a
end
--]]

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

	return Processing.SetFillColor(acolor)
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

	table.insert(Processing.Actors, actor)
	if actor.Render then
		addgraphic(actor)
	end
end

function addgraphic(agraphic)
	if not agraphic then return end

	table.insert(Processing.Graphics, agraphic)
end
