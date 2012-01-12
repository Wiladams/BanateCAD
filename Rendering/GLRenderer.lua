--
-- GLRenderer.wlua
--
-- The renderer for Banate CAD
--
-- Copyright (c) 2011  William Adams
--

require ("luagl")
require ("luaglu")
--require "Color"
local class = require "pl.class"

RenderMode = {
	POINT=1,
	SEQUENCE=2,
	LOOP=3,
	SOLID=4,
	}

class.GLRenderer()
function GLRenderer:_init(params)
	params = params or {}		-- create object if user does not provide one

	self.transform = {}

	local black = Color(0,0,0,255)
	local white = Color(255, 255, 255, 255)
	local gray = Color(53, 53, 53, 255)

	self:SetStrokeColor(black)
	self:SetFillColor(white)
	self:SetBackgroundColor(gray)

end

--=========================================
--	TRANSFORM PRIMITIVES
--=========================================
function GLRenderer.SaveTransform(self)
	gl.PushMatrix()
end

function GLRenderer.RestoreTransform(self)
	gl.PopMatrix()
end

function GLRenderer.Translate(self, atrans)
	if atrans == nil then return end

	gl.Translate(
		atrans[1],
		atrans[2],
		atrans[3]
		);
end

function GLRenderer.Scale(self, atrans)
	gl.Scale(
		atrans[1],
		atrans[2],
		atrans[3]
		);
end

function GLRenderer.Rotate(self, rots)
	-- Adjust for rotation
	-- X-axis Rotation
	gl.Rotate(rots[1], 1.0, 0.0, 0.0);

	-- Y-axis Rotation
	gl.Rotate(rots[2], 0.0, 1.0, 0.0);

	-- Z-axis Rotation
	gl.Rotate(rots[3], 0.0, 0.0, 1.0);
end

--=========================================
--	MATERIAL PRIMITIVES
--=========================================
--[[
	Ambient
	Diffuse
	Specular
	Shininess
	Emission

	Face
--]]
function GLRenderer.ApplyMaterial(self, mat)
	gl.ColorMaterial(gl.FRONT_AND_BACK, gl.AMBIENT_AND_DIFFUSE)
	gl.Enable(gl.COLOR_MATERIAL)

	local face=gl.FRONT

	if mat.Ambient ~= nil then
		gl.Material(face, gl.AMBIENT, mat.Ambient)
	end

	if mat.Diffuse ~= nil then
		gl.Material(face, gl.DIFFUSE, mat.Diffuse)
	end

	if mat.Specular ~= nil then
		gl.Material(face, gl.SPECULAR, mat.Specular)
	end

	if mat.Shininess ~= nil then
		gl.Material(face, gl.SHININESS, mat.Shininess)
	end

	if mat.Emission ~= nil then
		gl.Material(face, gl.EMISSION, mat.Emission)
	end
end

function GLRenderer.SetAntiAlias(self, antialiasing)
	if antialiasing then
		gl.Enable(gl.POINT_SMOOTH)
		gl.Enable(gl.LINE_SMOOTH)
		gl.Enable(gl.POLYGON_SMOOTH)

		--gl.Enable(gl.BLEND);
		--gl.BlendFunc(gl.SRC_ALPHA_SATURATE, gl.ONE);
		--gl.Disable(gl.DEPTH_TEST);            -- Disables Depth Testing
	else
		gl.Disable(gl.POINT_SMOOTH)
		gl.Disable(gl.LINE_SMOOTH)
		gl.Disable(gl.POLYGON_SMOOTH)

		--gl.Enable(gl.BLEND);
		--gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
		--gl.Disable(gl.DEPTH_TEST);            -- Disables Depth Testing
	end
end

function GLRenderer.SetPointSize(self, ptsize)
	self.PointSize = ptsize
	gl.PointSize(ptsize)
end

function GLRenderer.SetLineCap(self, cap)
	self.LineCap = cap	self.canvas:LineCap(cap)
end

function GLRenderer.SetLineJoin(self, join)
	self.LineJoin = join
end

function GLRenderer.SetLineWidth(self, lwidth)
	self.LineWidth = lwidth
	gl.LineWidth(lwidth)
end

function GLRenderer.SetStrokeColor(self, acolor)
	self.StrokeColor = acolor;
end

function GLRenderer.SetFillColor(self, acolor)
	self.FillColor = acolor;
end

function GLRenderer.SetBackgroundColor(self, acolor)
	self.BackgroundColor = acolor;
end

--=========================================
--	DRAWING PRIMITIVES
--=========================================
function GLRenderer.vertex(self, vert)
	gl.Vertex (vert)
end

function GLRenderer.DrawPoint(self, apt)
	if self.StrokeColor ~= nil then
		gl.Color(self.StrokeColor[1],self.StrokeColor[2],self.StrokeColor[3],self.StrokeColor[4])
	end

	if self.PointSize ~= nil then
		gl.PointSize(self.PointSize)
	end

	gl.Begin(gl.POINTS)
		gl.Vertex(apt)
	gl.End()
end

function GLRenderer.DrawLine(self, aline)
	if self.StrokeColor ~= nil then
		gl.Color(self.StrokeColor[1],self.StrokeColor[2],self.StrokeColor[3],self.StrokeColor[4])
	end

	--gl.LineWidth(width)
	gl.Begin(gl.LINES)
		gl.Vertex(aline[1])
		gl.Vertex(aline[2])
	gl.End()
end

function GLRenderer.DrawPolygon(self, pts, mode)
	mode = mode or RenderMode.SOLID

	if mode == RenderMode.LOOP then
		gl.Begin(gl.LINE_LOOP)

		if self.StrokeColor ~= nil then
			gl.Color(self.StrokeColor[1],self.StrokeColor[2],self.StrokeColor[3],self.StrokeColor[4])
		end
	elseif mode == RenderMode.SOLID then
		gl.Begin(gl.POLYGON)

		if self.FillColor ~= nil then
			gl.Color(self.FillColor[1],self.FillColor[2],self.FillColor[3],self.FillColor[4])
		end
	end


	for _,vert in ipairs(pts) do
		gl.Vertex(vert);
	end

	gl.End()
end

function GLRenderer.DrawTriangle(self, tri, mode)
	mode = mode or RenderMode.SOLID

-- tri.Vertices
-- tri.Normals
-- tri.Colors

	if #tri.Normals == 1 then
		gl.Normal(normal[1], normal[2], normal[3]);
	end

	if mode == RenderMode.LOOP then
		gl.Begin(gl.LINE_LOOP)
	elseif mode == RenderMode.SOLID then
		gl.Begin(gl.TRIANGLES)
	end

	for _,vert in ipairs(tri.Vertices) do
		gl.Vertex(vert);
	end

	gl.End()
end

--[[
	TYPOGRAPHY
--]]


function GLRenderer.SetFont(self, fontname, style, points)
end

function GLRenderer.SetTextAlignment(self, alignment)
end

function GLRenderer.DrawText(self, x, y, txt)
end

function GLRenderer.MeasureString(self, txt)
	return {0, 0}
end



function GLRenderer.Clear(self)
	self:ClearCanvas(self.BackgroundColor)
end

function GLRenderer.ClearCanvas(self, acolor)
	-- Set the background color
	-- And clear the background and depth buffers
	gl.ClearColor(
		acolor[1],
		acolor[2],
		acolor[3],
		acolor[4])
--	gl.Clear("COLOR_BUFFER_BIT")
	gl.Clear("COLOR_BUFFER_BIT,DEPTH_BUFFER_BIT,STENCIL_BUFFER_BIT")

	gl.Enable(gl.BLEND);
	gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
	gl.Disable(gl.DEPTH_TEST);            -- Disables Depth Testing

	gl.Flush()
	gl.Finish()
end
