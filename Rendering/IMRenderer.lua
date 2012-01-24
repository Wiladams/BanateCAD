require "imlua"
require "cdlua"
require "cdluaim"

--require "color"
--require "Texture"
--local Renderer = require "Renderer"
--require "Transformer"
require "CDTransformer"

local class = require "pl.class"

class.IMRenderer(Renderer)

function IMRenderer:_init(awidth, aheight)
	self.width = awidth;
	self.height = aheight;


	-- Create the basic image
	self.Image = im.ImageCreate(awidth, aheight, im.RGB, im.BYTE)
	self.Image:AddAlpha();

	-- Create canvas for drawing commands
	self.canvas = self.Image:cdCreateCanvas()  -- Creates a CD_IMAGERGB canvas

	-- Activate the canvas so we can draw into it
	self.canvas:Activate();

	self.Transformer = CDTransformer(self.canvas);


	local black = Color(0,0,0,255)
	local white = Color(255, 255, 255, 255)
	local gray = Color(53, 53, 53, 255)

	self:SetStrokeColor(black)
	self:SetFillColor(white)
	self:SetBackgroundColor(gray)
end

function IMRenderer.ApplyAttributes(self)
--[[
print("IMRenderer.ApplyAttributes - BEGIN")
print(self.StrokeColor)
print(self.FillColor)
print(self.BackgroundColor)
--]]
	-- Apply attributes before any drawing occurs
	self:SetStrokeColor(self.StrokeColor)
	self:SetFillColor(self.FillColor)
	self:SetBackgroundColor(self.BackgroundColor)
	--self:SetSmooth(Processing.Smooth)
end

function IMRenderer.get(self, x, y)
	local row = self.height-1 - y
	--local row = y
	local col = x

	local r = self.Image[0][row][col]
	local g = self.Image[1][row][col]
	local b = self.Image[2][row][col]
	local a = self.Image[3][row][col]

	return Color(r*255,g*255,b*255,a*255)
end

function IMRenderer.set(self, x, y, acolor)

	local row = self.height-1 - y
	--local row = y
	local col = x


	self.Image[0][row][col] = acolor.R
	self.Image[1][row][col] = acolor.G
	self.Image[2][row][col] = acolor.B
	self.Image[3][row][col] = acolor.A
end

function IMRenderer.loadPixels(self)
end

function IMRenderer.CreateTexture(self)
	-- Copy the data to the actual texture object
	local gldata, glformat = self.Image:GetOpenGLData()

	self.glformat = glformat;

	-- Initial copy to texture using the userdata
	self.Texture = Texture(self.width, self.height, glformat, gldata)
end

function IMRenderer.GetTexture(self)
	if self.Texture ~= nil then
		return self.Texture
	end

	self:CreateTexture();

	return self.Texture;
end

function IMRenderer.updatePixels(self)
	-- Copy the data to the actual texture object

	local tx = self:GetTexture()
	if tx ~= nil then
		tx:CopyGLData(self.Image)
	end
end

function IMRenderer.Render(self, x, y, awidth, aheight)
	local tx = self:GetTexture()
	if tx ~= nil then
		tx:Render(x, y, awidth, aheight)
	end
end


--[==========[
	Rendering
--]==========]

--[[
	ATTRIBUTES
--]]
function IMRenderer.SetPointSize(self, asize)
end

function IMRenderer.SetLineCap(self, cap)
	self.LineCap = cap
	self.canvas:LineCap(cap)
end

function IMRenderer.SetLineJoin(self, join)
	self.LineJoin = join
	self.canvas:LineJoin(join)
end

function IMRenderer.SetLineWidth(self, lwidth)
	self.LineWidth = lwidth
	self.canvas:LineWidth(lwidth)
end

function IMRenderer.SetStrokeColor(self, acolor)
	self.StrokeColor = acolor;

	local ecolor = cd.EncodeColor(acolor.R, acolor.G, acolor.B)
	self.EStrokeColor = cd.EncodeAlpha(ecolor, acolor.A)
end

function IMRenderer.SetFillColor(self, acolor)
	self.FillColor = acolor;

	local ecolor = cd.EncodeColor(acolor.R, acolor.G, acolor.B)
	self.EFillColor = cd.EncodeAlpha(ecolor, acolor.A)
end

function IMRenderer.SetBackgroundColor(self, acolor)
	self.BackgroundColor = acolor;

	local ecolor = cd.EncodeColor(acolor.R, acolor.G, acolor.B)
	local bgcolor = cd.EncodeAlpha(ecolor, acolor.A)
	self.canvas:SetBackground(bgcolor)
end

function IMRenderer.SetAntiAlias(self, smoothing)

end

function IMRenderer.Clear(self)
	self.canvas:Clear()
end

--[[
	PRIMITIVES
--]]
function IMRenderer.DrawPoint(self, x, y)
	self:set(x,y,self.StrokeColor);
end

function IMRenderer.DrawLine(self, x1, y1, x2, y2)
	self.canvas:SetForeground(self.EStrokeColor)
	self.canvas:Line(x1, y1, x2, y2)
end

function IMRenderer.DrawBezier(self, p1, p2, p3, p4)
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

function IMRenderer.DrawCurve(self, p1, p2, p3, p4)
	local pts = {p1, p2, p3, p4}
	local curveSteps = 30;

	local cv4 = cubic_vec3_to_cubic_vec4(pts);

	local lastPoint = catmull_eval(0, 1/2, cv4);
	for i=1, curveSteps do
		local u = i/curveSteps;
		local cpt = catmull_eval(u, 1/2, cv4);

		line(lastPoint[1], lastPoint[2], cpt[1], cpt[2])
		lastPoint = cpt;
	end
end

function IMRenderer.DrawPolygon(self, pts)
	local canvas2D = self.canvas

	-- First do the solid portion using
	-- the fill color
	if self.FillColor.A ~= 0 then
		canvas2D:Foreground(self.EFillColor)
		canvas2D:Begin(cd.FILL)
		for _,pt in ipairs(pts) do
			canvas2D:Vertex(pt[1], pt[2])
		end
		canvas2D:End()
	end

	-- Then do it again with the stroke Color
	if self.StrokeColor.A ~= 0 then
		canvas2D:Foreground(self.EStrokeColor)
		canvas2D:Begin(cd.CLOSED_LINES)
		for _,pt in ipairs(pts) do
			canvas2D:Vertex(pt[1], pt[2])
		end
		canvas2D:End()
	end
end


function IMRenderer.DrawRect(self, x, y, w, h)
	local pts = {
		Point3D(x, y, 0),
		Point3D(x, y+h, 0),
		Point3D(x+w, y+h, 0),
		Point3D(x+w, y, 0),
	}

	self:DrawPolygon(pts)
end

function IMRenderer.DrawTriangle(self, x1, y1, x2, y2, x3, y3)
	local pts = {
		Point3D(x1, y1, 0),
		Point3D(x3, y3, 0),
		Point3D(x2, y2, 0),
	}

	self:DrawPolygon(pts)
end


--[[
	TYPOGRAPHY
--]]


function IMRenderer.SetFont(self, fontname)
--print("IMRenderer.SetFont: ", fontname)
	self.canvas:NativeFont(fontname)
end

function IMRenderer.SetTextAlignment(self, alignment)
	self.canvas:TextAlignment(alignment);
end

function IMRenderer.DrawText(self, x, y, txt)
	-- To get text to display properly, we have to
	-- go back to the CDs native orientation, or the
	-- baseline is not always correct.
	self.canvas:YAxisMode(0);
	y = self.height - 1 - y

	self.canvas:Text(x, y, txt)

	-- Now go back to an inverted axis so the
	-- rest of the system can render correctly
	self.canvas:YAxisMode(1);
end

function IMRenderer.MeasureString(self, txt)
	local twidth, theight = self.canvas:GetTextSize(txt)

	return {twidth, theight}
end


--[==============================[
	TRANSFORMATION
--]==============================]
function IMRenderer.ResetTransform(self)
	self.Transformer:Clear()

	-- invert the Y Axis
	self.canvas:YAxisMode(1);
end

--[[
function IMRenderer.FlipYAxis(self)
	self.YScale = -self.YScale;

	self.Transformer:Translate(0, self.height, 0)
	self.Transformer:Scale(1, self.YScale, 1)

end
--]]


function IMRenderer.Translate(self, dx, dy, dz)
	dz = dz or 0
	dy = dy or 0

	self.Transformer:Translate(dx, dy, dz)
end

function IMRenderer.Rotate(self, rads)
	self.Transformer:Rotate(rads)
end

function IMRenderer.Scale(self, sx, sy, sz)
	self.Transformer:Scale(sx, sy, sz)
end

function IMRenderer.PushMatrix(self)
	self.Transformer:PushMatrix()
end

function IMRenderer.PopMatrix(self)
	self.Transformer:PopMatrix()
end


return IMRenderer
