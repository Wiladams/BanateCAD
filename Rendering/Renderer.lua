require "imlua"
require "cdlua"
require "cdluaim"

require "CDTransformer"

local class = require "pl.class"

class.Renderer()

function Renderer:_init(awidth, aheight, framebuffer)
	self.width = awidth;
	self.height = aheight;
	self.FrameBuffer = framebuffer;

	-- Create the basic image
	--self.Image = im.ImageCreate(awidth, aheight, im.RGB, im.BYTE)
	--self.Image:AddAlpha();


	-- Create canvas for drawing commands
	--self.canvas = self.Image:cdCreateCanvas()  -- Creates a CD_IMAGERGB canvas
	--self.Transformer = CDTransformer(self.canvas);

	-- Activate the canvas so we can draw into it
	--self.canvas:Activate();
	--self.canvas:YAxisMode(1)	-- Invert the y-axis

	--local black = Color(0,0,0,255)
	--local white = Color(255, 255, 255, 255)
	--local gray = Color(53, 53, 53, 255)

	--self:SetStrokeColor(black)
	--self:SetFillColor(white)
	--self:SetBackgroundColor(gray)
end

function Renderer.ApplyAttributes(self)
	-- Apply attributes before any drawing occurs
	self:SetStrokeColor(self.StrokeColor)
	self:SetFillColor(self.FillColor)
	self:SetBackgroundColor(self.BackgroundColor)
	--self:SetSmooth(Processing.Smooth)
end


--[==========[
	Rendering
--]==========]
function Renderer.loadPixels(self)
end

--[[
	ATTRIBUTES
--]]
function Renderer.SetPointSize(self, asize)
	self.PointSize = asize;
end

function Renderer.SetLineCap(self, cap)
	self.LineCap = cap;
end

function Renderer.SetLineJoin(self, join)
	self.LineJoin = join;
end

function Renderer.SetLineWidth(self, lwidth)
	self.LineWidth = lwidth;
end

function Renderer.SetStrokeColor(self, acolor)
	self.StrokeColor = acolor;
end

function Renderer.SetFillColor(self, acolor)
	self.FillColor = acolor;
end

function Renderer.SetBackgroundColor(self, acolor)
	self.BackgroundColor = acolor;
end

function Renderer.SetAntiAlias(self, smoothing)
	self.AntiAlias = smoothing
end

function Renderer.Clear(self)
end

--[[
	PRIMITIVES
--]]
function Renderer.get(self, x, y)
	if self.FrameBuffer then
		return self.FrameBuffer:get(x,y)
	end

	return Color(0,0,0,0)
end

function Renderer.set(self, x, y, acolor)
	if self.FrameBuffer then
		self.FrameBuffer:set(x,y,acolor)
	end
end

function Renderer.DrawPoint(self, x, y)
	self:set(x,y,self.StrokeColor);
end

function Renderer.DrawLine(self, x1, y1, x2, y2)
	-- Implement a Bresenham algorithm to draw
	-- a line from points
end

function Renderer.DrawBezier(self, p1, p2, p3, p4)
	local pts = {p1, p2, p3, p4}
	local curveSteps = 30;

	local cv4 = cubic_vec3_to_cubic_vec4(pts);

	local lastPoint = bezier_eval(0, cv4);
	for i=1, curveSteps do
		local u = i/curveSteps;
		local cpt = bezier_eval(u, cv4);

		self:DrawLine(lastPoint[1], lastPoint[2], cpt[1], cpt[2])
		lastPoint = cpt;
	end
end

function Renderer.DrawCurve(self, p1, p2, p3, p4)
	local pts = {p1, p2, p3, p4}
	local curveSteps = 30;

	local cv4 = cubic_vec3_to_cubic_vec4(pts);

	local lastPoint = catmull_eval(0, 1/2, cv4);
	for i=1, curveSteps do
		local u = i/curveSteps;
		local cpt = catmull_eval(u, 1/2, cv4);

		self:DrawLine(lastPoint[1], lastPoint[2], cpt[1], cpt[2])
		lastPoint = cpt;
	end
end

function Renderer.DrawPolygon(self, pts)
	-- Raster Scan a polygon
end

function Renderer.DrawTriangle(self, x1, y1, x2, y2, x3, y3)
	local pts = {
		Point3D(x1, y1, 0),
		Point3D(x3, y3, 0),
		Point3D(x2, y2, 0),
	}

	self:DrawPolygon(pts)
end

function Renderer.DrawRect(self, x, y, w, h)
	local pts = {
		Point3D(x, y, 0),
		Point3D(x, y+h, 0),
		Point3D(x+w, y+h, 0),
		Point3D(x+w, y, 0),
	}

	self:DrawPolygon(pts)
end

function Renderer.DrawEllipse(self, centerx, centery, awidth, aheight)
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

	self:DrawPolygon(pts)
end




--[[
	TYPOGRAPHY
--]]

function Renderer.SetFont(self, fontname, style, points)
end

function Renderer.SetTextAlignment(self, alignment)
end

function Renderer.DrawText(self, x, y, txt)
end

--[==============================[
	TRANSFORMATION
--]==============================]
function Renderer.ResetTransform(self)
	self.Transformer:Clear()
end

function Renderer.Translate(self, dx, dy, dz)
	dz = dz or 0
	dy = dy or 0

	self.Transformer:Translate(dx, dy, dz)
end

function Renderer.Rotate(self, rads)
	self.Transformer:Rotate(rads)
end

function Renderer.Scale(self, sx, sy, sz)
	self.Transformer:Scale(sx, sy, sz)
end

function Renderer.PushMatrix(self)
	self.Transformer:PushMatrix()
end

function Renderer.PopMatrix(self)
	self.Transformer:PopMatrix()
end

return Renderer
