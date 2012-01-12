require "imlua"
require "cdlua"
require "cdluaim"

--require "color"
--require "Texture"

local class = require "pl.class"

class.Renderer()

function Renderer:_init(awidth, aheight)
	self.width = awidth;
	self.height = aheight;

	-- Create the basic image
	self.Image = im.ImageCreate(awidth, aheight, im.RGB, im.BYTE)
	self.Image:AddAlpha();

	-- Copy the data to the actual texture object
	--self:CreateTexture()

	-- Create canvas for drawing commands
	self.canvas = self.Image:cdCreateCanvas()  -- Creates a CD_IMAGERGB canvas

	-- Activate the canvas so we can draw into it
	self.canvas:Activate();
	self.canvas:YAxisMode(1)	-- Invert the y-axis

	local black = Color(0,0,0,255)
	local white = Color(255, 255, 255, 255)
	local gray = Color(53, 53, 53, 255)

	self:SetStrokeColor(black)
	self:SetFillColor(white)
	self:SetBackgroundColor(gray)
end

function Renderer.ApplyAttributes(self)
--[[
print("Renderer.ApplyAttributes - BEGIN")
print(self.StrokeColor)
print(self.FillColor)
print(self.BackgroundColor)
--]]
	-- Apply attributes before any drawing occurs
	self:SetStrokeColor(self.StrokeColor)
	self:SetFillColor(self.FillColor)
	self:SetBackgroundColor(self.BackgroundColor)
end


--[==========[
	Rendering
--]==========]

--[[
	ATTRIBUTES
--]]
function Renderer.SetPointSize(self, asize)
end

function Renderer.SetLineCap(self, cap)
	self.LineCap = cap
end

function Renderer.SetLineJoin(self, join)
	self.LineJoin = join
end

function Renderer.SetLineWidth(self, lwidth)
	self.LineWidth = lwidth
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
end

function Renderer.Clear(self)
end

--[[
	PRIMITIVES
--]]
function Renderer.get(self, x, y)
	return Color(0,0,0,0)
end

function Renderer.set(self, x, y, acolor)
end

function Renderer.DrawPoint(self, x, y)
	self:set(x,y,self.StrokeColor);
end

function Renderer.DrawLine(self, x1, y1, x2, y2)
	-- Implement a Bresenham algorithm to draw
	-- a line from points

end

function Renderer.DrawPolygon(self, pts)
	-- Raster Scan a polygon
end

function Renderer.DrawRect(self, x, y, w, h)
	local pts = {
		Vector3D.new{x, y, 0},
		Vector3D.new{x, y+h, 0},
		Vector3D.new{x+w, y+h, 0},
		Vector3D.new{x+w, y, 0},
	}

	self:DrawPolygon(pts)
end

function Renderer.DrawTriangle(self, pt1, pt2, pt3)
	local pts = {pt1, pt2, pt3}

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

return Renderer
