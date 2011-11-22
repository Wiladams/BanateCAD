--
-- Renderer.wlua
--
-- The renderer for FabuCAD
--
-- Copyright (c) 2011  William Adams
--

require ("luagl")
require ("luaglu")
require ("openscad_print")
require ("CADVM")
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
--	DRAWING PRIMITIVES
--=========================================
function Renderer.vertex(self, vert)
	gl.Vertex (vert)
end

function Renderer.DrawLine(self, line)
--print("Renderer.DrawLine")
	gl.LineWidth(line[3])
	gl.Begin(gl.LINES)
		gl.Vertex(line[1])
		gl.Vertex(line[2])
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

	if norm ~= nil then
		gl.Normal(norm[1], norm[2], norm[3]);
	end

	for i,vindex in ipairs(face) do
		self:vertex(omesh.vertices[vindex])
	end
end

function Renderer.DisplayMesh(self, omesh)

	if (omesh == nil) then return end

	-- if the mesh has a display list, use that to
	-- render the mesh
	if omesh.displaylist ~= nil then
		gl.CallList(omesh.displaylist);
		return
	end

	local faceslen = #omesh.faces

	-- If we are here, the mesh did not have a display list
	-- Create and open the display list to do the rendering
	omesh.displaylist = gl.GenLists(1)
	gl.NewList(omesh.displaylist, gl.COMPILE)

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

	gl.EndList();
	gl.CallList(omesh.displaylist);

end



function Renderer.DisplayScene(self, ascene)
	if (ascene.commands == nil or #defaultscene.commands == 0) then
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
			cmd.value:Render(self);
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


