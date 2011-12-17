--
-- GLRenderer.wlua
--
-- The renderer for Banate CAD
--
-- Copyright (c) 2011  William Adams
--

require ("luagl")
require ("luaglu")


RenderMode = {
	POINT=1,
	SEQUENCE=2,
	LOOP=3,
	SOLID=4,
	}

GLRenderer = {}
function GLRenderer.new(self, o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	o.transform = {}

	return o
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

function GLRenderer.SetAntiAlias(antialiasing)
	if antialiasing then
		gl.Enable(gl.POINT_SMOOTH)
	else
		gl.Disable(gl.POINT_SMOOTH)
	end
end

function GLRenderer.SetPointSize(self, ptsize)
	gl.PointSize(ptsize)
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


	gl.Begin(gl.POINTS)
		gl.Vertex(apt)
	gl.End()
end

function GLRenderer.DrawLine(self, aline)
	if self.StrokeColor ~= nil then
		gl.Color(self.StrokeColor[1],self.StrokeColor[2],self.StrokeColor[3],self.StrokeColor[4])
	end

	gl.LineWidth(aline[3])
	gl.Begin(gl.LINES)
		gl.Vertex(aline[1])
		gl.Vertex(aline[2])
	gl.End()
end

function GLRenderer.DrawPolygon(self, pts, mode)
--print("GLRenderer.DrawPolygon",pts)

	mode = mode or RenderMode.SOLID

	if mode == RenderMode.LOOP then
		gl.Begin(gl.LINE_LOOP)
	elseif mode == RenderMode.SOLID then
		gl.Begin(gl.POLYGON)
	end

	if self.FillColor ~= nil then
		gl.Color(self.FillColor[1],self.FillColor[2],self.FillColor[3],self.FillColor[4])
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






function GLRenderer.ClearCanvas(self, acolor)
	-- Set the background color
	-- And clear the background and depth buffers
	gl.ClearColor(
		acolor[1],
		acolor[2],
		acolor[3],
		acolor[4])
	gl.Clear("COLOR_BUFFER_BIT")
--	gl.Clear("COLOR_BUFFER_BIT,DEPTH_BUFFER_BIT,STENCIL_BUFFER_BIT")

	gl.Enable(gl.BLEND);
	gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
	gl.Disable(gl.DEPTH_TEST);            -- Disables Depth Testing

	gl.Flush()
end
