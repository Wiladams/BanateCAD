--
-- Construct the default GL Canvas

require "AsyncQueue"

defaultglcanvas = iup.glcanvas({
		BUFFER = "SINGLE",
		EXPAND = "YES",
		--RASTERSIZE = "1024x768",
		--DEPTH_SIZE = "16"
		});



function defaultglcanvas.action(self)
	iup.GLMakeCurrent(self);

	gl.Flush();
end


function defaultglcanvas.map_cb(self)
	iup.GLMakeCurrent(self);

	-- Set it up the way we want it
	-- We must do this here, or we don't get
	-- alpha transparency
	gl.Enable(gl.BLEND);
	gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
	gl.Disable(gl.DEPTH_TEST);            -- Disables Depth Testing


--[[
	local canvas2D = cd.CreateCanvas(cd.IUP, self)
--assert(canvas2D ~= nil, "defaultcanvas.map_cb - cd canvas is nil")
	self.canvas2D = canvas2D
	canvas2D:Activate()
	canvas2D:YAxisMode(0)	-- Invert the y-axis
--]]
end

function defaultglcanvas.resize_cb(self, w, h)
	iup.GLMakeCurrent(self)

	Processing.ReSize(w, h)
end


-- Keyboard Activity
--[[
function KeyboardActivityArgs:_init(params)

	self.Keyboard = params.Keyboard;
	self.Window = params.Window;
	self.EventType = params.EventType;
	self.VirtualKeyCode = params.KeyCode;
	self.KeyMasks = params.KeyMasks;
	self.KeyChar = params.KeyChar;

	self.RepeatCount = params.RepeatCount or 0;
	self.OEMScanCode = params.OEMScanCode;
	self.IsExtended = params.Extended;
--]]
function defaultglcanvas:keypress_cb(c, press)
	print("Processing.lua.keypress_cb: ", c, press);
	local et = KeyActivityType.KeyDown
	if press == 0 then
		et = KeyActivityType.KeyUp
	end

	local ke = KeyboardActivityArgs{
		EventType = et,
		KeyChar = c,
	}

	defaultuiqueue:Enqueue(ke)
	--Processing.KeyActivity(ke)

	return iup.DEFAULT
end

function defaultglcanvas:k_any(c)
	print("Processing.lua.key_any: ", c);

	return iup.CONTINUE
end

-- Need to map from IUP button descriptors to
-- our own
local mouseButtonMap = {
	[iup.BUTTON1] = MouseButton.Left,
	[iup.BUTTON2] = MouseButton.Middle,
	[iup.BUTTON3] = MouseButton.Right,
	}

-- Mouse Activity
function defaultglcanvas.motion_cb(self, x, y, status)
	local ma = MouseActivityArgs({
		Device = nil ;
		ActivityType = MouseActivityType.MouseMove;
		ButtonActivity = MouseButtonActivity.None;
		CoordinateSpace = MouseCoordinateSpace.Window;
		MovementType = MouseMovementType.Absolute;
		Window = self;

		Button = MouseButton.None;
		Clicks = 0;
		X = x;
		Y = y;
		Delta = 0;
		KeyFlags = status;
	})
--print("defaultglcanvas.motion_cb: ", ma)
	--Processing.MouseActivity(ma)
	defaultuiqueue:Enqueue(ma)
end

-- Indicates mouse button activity, either pressed or released

function defaultglcanvas.button_cb(self, but, pressed, x, y, status)
	local mat = MouseActivityType.MouseDown
	local clicks = 1;
	local bactive = MouseButtonActivity.None

	if pressed == 1 then
		mat = MouseActivityType.MouseDown
		if iup.isdouble(status) then
			clicks = 2
		end
	elseif pressed == 0 then
		mat = MouseActivityType.MouseUp
	end

	local ma = MouseActivityArgs({
		Device = nil ;
		ActivityType = mat;
		ButtonActivity = MouseButtonActivity.None;
		CoordinateSpace = MouseCoordinateSpace.Window;
		MovementType = MouseMovementType.Absolute;
		Window = self;

		Button = mouseButtonMap[but] or MouseButton.None;
		Clicks = clicks;
		X = x;
		Y = y;
		Delta = 0;
		KeyFlags = status;
	})

	defaultuiqueue:Enqueue(ma)
	--Processing.MouseActivity(ma)
end

function defaultglcanvas.wheel_cb(self, delta, x, y, status)
	local ma = MouseActivityArgs({
		Device = nil ;
		ActivityType = MouseActivityType.MouseWheel;
		ButtonActivity = MouseButtonActivity.MouseWheel;
		CoordinateSpace = MouseCoordinateSpace.Window;
		MovementType = MouseMovementType.Absolute;
		Window = self;

		Button = MouseButton.Wheel;
		Clicks = 0;
		X = x;
		Y = y;
		Delta = delta;
		KeyFlags = status;
	})

	defaultuiqueue:Enqueue(ma)
	--Processing.MouseActivity(ma)
end
