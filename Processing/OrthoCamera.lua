--
-- Do the work necessary to properly configure and place
-- the 'camera' in the scene.
--
FARAWAY = 100000;

OrthoCamera={}
OrthoCamera.Distance = FARAWAY
OrthoCamera.w_h_ratio = 1
OrthoCamera.viewer_distance = 100
OrthoCamera.Width = 640
OrthoCamera.Height = 480

function OrthoCamera.SetSize(width, height)
	iup.GLMakeCurrent(defaultglcanvas);

	OrthoCamera.Width = width
	OrthoCamera.Height = height
	OrthoCamera.w_h_ratio = math.sqrt(width/height);

--print("OrthoCamers.SetSize", width, height)
	gl.Viewport(0, 0, width, height)
end


function OrthoCamera.Render()
	-- First setup the orthographic projection
	gl.MatrixMode(gl.PROJECTION);
	gl.LoadIdentity()

	glu.Ortho2D(0, OrthoCamera.Width, 0, OrthoCamera.Height)
	gl.Scale(1, -1, 1)
	gl.Translate(0, -OrthoCamera.Height, 0)

	--local l = OrthoCamera.Distance/ 10;
	--gl.Ortho(-OrthoCamera.w_h_ratio*l, OrthoCamera.w_h_ratio*l, -(1/OrthoCamera.w_h_ratio)*l, (1/OrthoCamera.w_h_ratio)*l,-FARAWAY, FARAWAY);


	-- Now setup for the lookat
	gl.MatrixMode("MODELVIEW")
	gl.LoadIdentity()

--[[
	local pos = {OrthoCamera.Width/2, OrthoCamera.Height/2, OrthoCamera.viewer_distance}
	local at = {OrthoCamera.Width/2,OrthoCamera.Height/2,0}
	local up = {0,0,1}
	glu.LookAt(pos[1], pos[2], pos[3],	-- position
		at[1], at[2], at[3],			-- look at
		up[1], up[2], up[3])			-- up vector
--]]

	-- Adjust for rotation
	--gl.Rotate(self.obj_rot[1], 1.0, 0.0, 0.0);
	--gl.Rotate(self.obj_rot[2], 0.0, 1.0, 0.0);
	--gl.Rotate(self.obj_rot[3], 0.0, 0.0, 1.0);

	-- Adjust for translation
	--gl.Translate(self.obj_trans[1], self.obj_trans[2],self.obj_trans[3]);
end
