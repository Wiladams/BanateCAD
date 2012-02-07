require "imlua"
require "cdlua"
require "cdluaim"

require"iuplua"
require"iupluacd"

require "Renderer"
require "CDTransformer"

local class = require "pl.class"

class.IMRenderer(Renderer)

function IMRenderer:_init(awidth, aheight)
--	self.width = awidth;
--	self.height = aheight;


	-- Create the basic image
	self.Image = im.ImageCreate(awidth, aheight, im.RGB, im.BYTE)
	self.Image:AddAlpha();

	-- Create canvas for drawing commands
	self.canvas = self.Image:cdCreateCanvas()  -- Creates a CD_IMAGERGB canvas

	-- Activate the canvas so we can draw into it
	self.canvas:Activate();

	self.Transformer = CDTransformer(self.canvas);


	Renderer._init(self, awidth, aheight, self)

	local black = Color(0,0,0,255)
	local white = Color(255, 255, 255, 255)
	local gray = Color(53, 53, 53, 255)

	self:SetStrokeColor(Colors.Black)
	self:SetFillColor(Colors.White)
	self:SetBackgroundColor(Colors.DarkGray)
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

function IMRenderer.Render(self, acanvas, x, y, awidth, aheight)
	local posx = x or 0
	y = y or 0
	local posy = y + self.height
	local w = awidth or 0
	local h = aheight or 0

--	self.Image:cdCanvasPutImageRect(acanvas, posx, posy, w, h, 0, 0, 0, 0)

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

function IMRenderer.DrawLine(self, x1, y1, x2, y2)
	self.canvas:SetForeground(self.EStrokeColor)
	self.canvas:Line(x1, y1, x2, y2)
end

function IMRenderer.DrawPolygon(self, pts)
	local canvas2D = self.canvas

	-- First do the solid portion using
	-- the fill color
	if self.FillColor.A ~= 0 then
		canvas2D:SetForeground(self.EFillColor)
		canvas2D:Begin(cd.FILL)
		for _,pt in ipairs(pts) do
			canvas2D:Vertex(pt[1], pt[2])
		end
		canvas2D:End()
	end

	-- Then do it again with the stroke Color
	if self.StrokeColor.A ~= 0 then
		canvas2D:SetForeground(self.EStrokeColor)
		canvas2D:Begin(cd.CLOSED_LINES)
		for _,pt in ipairs(pts) do
			canvas2D:Vertex(pt[1], pt[2])
		end
		canvas2D:End()
	end
end


function IMRenderer.DrawImage(self, img, x,y, w,h)
	local posx = x;
	local posy = y + img.Frame.Height

	--self.canvas:PutImageRectRGB(img.Image, x, y, w, h,
	--	0, 0, 0, 0)

	-- use default values
	img.Image:cdCanvasPutImageRect(self.canvas, posx, posy, w, h, 0, 0, 0, 0)
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

	self.canvas:SetForeground(self.EStrokeColor)
	self.canvas:Text(x, y, txt)

	-- Now go back to an inverted axis so the
	-- rest of the system can render correctly
	self.canvas:YAxisMode(1);
end

function IMRenderer.GetFontDimension(self)
	return self.canvas:GetFontDim()
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
