-- AxesBug.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
require ("luagl")
require ("luaglu")

AxesBug = {}
function AxesBug:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	o.LINEWIDTH = 1;
	o.COLOR = {0.5, 0.5, 0.5, 1};
	o.LENGTH = 50;

	return o
end

function AxesBug.Draw(self)
	-- Small axis bug in the lower left corner
	gl.DepthFunc(gl.ALWAYS);

	defaultviewer:SetupOrtho(1000,true);

	glu.LookAt(0.0, -1000, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0);

	gl.MatrixMode(gl.MODELVIEW);
	gl.LoadIdentity();
	gl.Rotate(defaultviewer.obj_rot[1], 1.0, 0.0, 0.0);
	gl.Rotate(defaultviewer.obj_rot[2], 0.0, 1.0, 0.0);
	gl.Rotate(defaultviewer.obj_rot[3], 0.0, 0.0, 1.0);

	gl.LineWidth(1);
	gl.Begin(gl.LINES);
	gl.Color(1.0, 0.0, 0.0);
	gl.Vertex(0, 0, 0); gl.Vertex(10, 0, 0);
	gl.Color(0.0, 1.0, 0.0);
	gl.Vertex(0, 0, 0); gl.Vertex(0, 10, 0);
	gl.Color(0.0, 0.0, 1.0);
	gl.Vertex(0, 0, 0); gl.Vertex(0, 0, 10);
	gl.End();

--[[
		GLdouble mat_model[16];
		glGetDoublev(GL_MODELVIEW_MATRIX, mat_model);

		GLdouble mat_proj[16];
		glGetDoublev(GL_PROJECTION_MATRIX, mat_proj);

		GLint viewport[4];
		glGetIntegerv(GL_VIEWPORT, viewport);

		GLdouble xlabel_x, xlabel_y, xlabel_z;
		gluProject(12, 0, 0, mat_model, mat_proj, viewport, &xlabel_x, &xlabel_y, &xlabel_z);
		xlabel_x = round(xlabel_x); xlabel_y = round(xlabel_y);

		GLdouble ylabel_x, ylabel_y, ylabel_z;
		gluProject(0, 12, 0, mat_model, mat_proj, viewport, &ylabel_x, &ylabel_y, &ylabel_z);
		ylabel_x = round(ylabel_x); ylabel_y = round(ylabel_y);

		GLdouble zlabel_x, zlabel_y, zlabel_z;
		gluProject(0, 0, 12, mat_model, mat_proj, viewport, &zlabel_x, &zlabel_y, &zlabel_z);
		zlabel_x = round(zlabel_x); zlabel_y = round(zlabel_y);

		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glTranslated(-1, -1, 0);
		glScaled(2.0/viewport[2], 2.0/viewport[3], 1);

		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();

		// FIXME: This was an attempt to keep contrast with background, but is suboptimal
		// (e.g. nearly invisible against a gray background).
		int r,g,b;
		bgcol.getRgb(&r, &g, &b);
		glColor3d((255.0-r)/255.0, (255.0-g)/255.0, (255.0-b)/255.0);
		glBegin(GL_LINES);
		// X Label
		glVertex3d(xlabel_x-3, xlabel_y-3, 0); glVertex3d(xlabel_x+3, xlabel_y+3, 0);
		glVertex3d(xlabel_x-3, xlabel_y+3, 0); glVertex3d(xlabel_x+3, xlabel_y-3, 0);
		// Y Label
		glVertex3d(ylabel_x-3, ylabel_y-3, 0); glVertex3d(ylabel_x+3, ylabel_y+3, 0);
		glVertex3d(ylabel_x-3, ylabel_y+3, 0); glVertex3d(ylabel_x, ylabel_y, 0);
		// Z Label
		glVertex3d(zlabel_x-3, zlabel_y-3, 0); glVertex3d(zlabel_x+3, zlabel_y-3, 0);
		glVertex3d(zlabel_x-3, zlabel_y+3, 0); glVertex3d(zlabel_x+3, zlabel_y+3, 0);
		glVertex3d(zlabel_x-3, zlabel_y-3, 0); glVertex3d(zlabel_x+3, zlabel_y+3, 0);
		glEnd();
--]]
	-- Restore perspective for next paint
	--if(not orthomode)
	--	setupPerspective();

end
