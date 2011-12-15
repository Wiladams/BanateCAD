--
-- Renderer.wlua
--
-- The renderer for Banate CAD
--
-- Copyright (c) 2011  William Adams
--

require ("luagl")
require ("luaglu")
require ("openscad_print")
--require ("CADVM")
--
-- Display the Scene
--

RenderMode = {
	POINT=1,
	SEQUENCE=2,
	LOOP=3,
	SOLID=4,
	}

Renderer = {}
function Renderer:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	o.transform = {}

	return o
end

function Renderer.ClearCachedObjects(self, ascene)
	if ascene == nil then return end

	for i, cmd in ipairs(ascene.commands) do
		if (cmd.command == CADVM.TRIMESH) then
			-- delete the display list item
			if cmd.value.displaylist ~= nil then
				gl.DeleteLists(cmd.value.displaylist, 1)
			end

			-- set display list to nil
			cmd.value.displaylist = nil;
		end
	end
end

--=========================================
--	TRANSFORM PRIMITIVES
--=========================================
function Renderer.SaveTransform(self)
	gl.PushMatrix()
end

function Renderer.RestoreTransform(self)
	gl.PopMatrix()
end

function Renderer.Translate(self, atrans)
	if atrans == nil then return end

	gl.Translate(
		atrans[1],
		atrans[2],
		atrans[3]
		);
end

function Renderer.Scale(self, atrans)
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
function Renderer.ApplyMaterial(self, mat)
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

--=========================================
--	DRAWING PRIMITIVES
--=========================================
function Renderer.vertex(self, vert)
	gl.Vertex (vert)
end

function Renderer.DrawLine(self, aline)
	if self.StrokeColor ~= nil then
		gl.Color(self.StrokeColor[1],self.StrokeColor[2],self.StrokeColor[3],self.StrokeColor[4])
	end

	gl.LineWidth(aline[3])
	gl.Begin(gl.LINES)
		gl.Vertex(aline[1])
		gl.Vertex(aline[2])
	gl.End()
end

function Renderer.DrawTriangle(self, tri, mode)
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

function Renderer.DisplayMeshFace(self, omesh, facenumber)
	local face = omesh.faces[facenumber];
	local norm = face.normal;
	local facecolor = face.Color;

	if norm ~= nil then
		gl.Normal(norm[1], norm[2], norm[3]);
	end

	if facecolor ~= nil then
		gl.Color(facecolor[1], facecolor[2], facecolor[3], facecolor[4]);
	end

	for i,vindex in ipairs(face) do
		self:vertex(omesh.vertices[vindex])
	end
end

function Renderer.DisplayMesh(self, omesh, uselist)

	if (omesh == nil) then return end

	uselist = uselist or true

	-- if the mesh has a display list, use that to
	-- render the mesh
	if uselist then
		if omesh.displaylist ~= nil then
			gl.CallList(omesh.displaylist);
			return
		end
	end

	local faceslen = #omesh.faces

	-- If we are here, the mesh did not have a display list
	-- Create and open the display list to do the rendering
	if uselist then
		omesh.displaylist = gl.GenLists(1)
		gl.NewList(omesh.displaylist, gl.COMPILE)
	end

	if (self.wireframe) then
			gl.Begin(gl.LINE_LOOP)
	else
			gl.Begin(gl.TRIANGLES)
	end

	gl.Enable(gl.CULL_FACE);
	gl.CullFace(gl.BACK);
	gl.Disable(gl.CULL_FACE);

	for i=1, faceslen do
			self:DisplayMeshFace(omesh, i)
	end
	gl.End();

	if uselist then
		gl.EndList();
		gl.CallList(omesh.displaylist);
	end
end





function Renderer.DisplayScene(self, ascene)
	if (ascene.commands == nil or #ascene.commands == 0) then
		--print("no commands")
		return
	end

	for i, cmd in ipairs(ascene.commands) do
		if (cmd.command == CADVM.FLUSHCACHE) then
			self:ClearCachedObjects();
		elseif (cmd.command == CADVM.TRIMESH) then
			-- modelview push Matrix
			-- Perform transforms
			gl.PushMatrix();
			local tfm = self.transform;
			if tfm.translate ~= nil then
				gl.Translate(tfm.translate[1], tfm.translate[2], tfm.translate[3]);
				tfm.translate = nil;
			end

			if tfm.scale ~= nil then
				gl.Scale(tfm.scale[1], tfm.scale[2], tfm.scale[3]);
				tfm.scale = nil;
			end
--			gl.Rotate(cmd.value.angle, cmd.value.axis);

			self:DisplayMesh(cmd.value)

			-- pop modelview Matrix
			gl.PopMatrix();
		elseif cmd.command == CADVM.SHAPE then
			-- modelview push Matrix
			-- Perform transforms
			gl.PushMatrix();
			local tfm = self.transform;
			if tfm.translate ~= nil then
				gl.Translate(tfm.translate[1], tfm.translate[2], tfm.translate[3]);
				tfm.translate = nil;
			end

			if tfm.scale ~= nil then
				gl.Scale(tfm.scale[1], tfm.scale[2], tfm.scale[3]);
				tfm.scale = nil;
			end
--			gl.Rotate(cmd.value.angle, cmd.value.axis);


			cmd.value:Render(self);

			-- pop modelview Matrix
			gl.PopMatrix();
		elseif cmd.command == CADVM.LINE then
			self:DrawLine(cmd.value)
		elseif cmd.command == CADVM.TRANSLATION then
			self.transform['translate'] = cmd.value;
		elseif cmd.command == CADVM.ROTATION then
			self.transform['rotate'] = cmd.value;
		elseif cmd.command == CADVM.SCALE then
			self.transform['scale'] = cmd.value;
		elseif cmd.command == CADVM.COLOR then
			gl.Color(cmd.value[1], cmd.value[2], cmd.value[3], cmd.value[4]);
		end

	end
end

function Renderer.ClearCanvas(self, acolor)
	-- Set the background color
	-- And clear the background and depth buffers
	gl.ClearColor(
		acolor[1],
		acolor[2],
		acolor[3],
		acolor[4])
	gl.Clear("COLOR_BUFFER_BIT,DEPTH_BUFFER_BIT,STENCIL_BUFFER_BIT")

end
