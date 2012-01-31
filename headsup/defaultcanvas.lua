require( "iuplua" )

--cv       = iup.canvas {size="300x100", xmin=0, xmax=99, posx=0, dx=10}
defaultcanvas = iup.canvas{
	EXPAND = "YES",
}

function defaultcanvas.action(self)
end


function defaultcanvas.map_cb(self)
	local canvas2D = cd.CreateCanvas(cd.IUP, self)
--assert(canvas2D ~= nil, "defaultcanvas.map_cb - cd canvas is nil")
	self.canvas2D = canvas2D
	canvas2D:Activate()
	canvas2D:YAxisMode(0)	-- Invert the y-axis
end

function defaultcanvas.resize_cb(self, w, h)
	--Processing.ReSize(w, h)
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
function defaultcanvas:keypress_cb(c, press)
	--print("defaultcanvas:keypress_cb: ", c, press);
	local et = KeyActivityType.KeyDown
	if press == 0 then
		et = KeyActivityType.KeyUp
	end

	local ke = KeyboardActivityArgs{
		EventType = et,
		KeyChar = c,
	}

	Processing.KeyActivity(ke)

	return iup.DEFAULT
end

function defaultcanvas:k_any(c)
	print("defaultcanvas:key_any: ", c);

	return iup.CONTINUE
end

-- Mouse Activity
function defaultcanvas:motion_cb(x, y, status)
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
	Processing.MouseActivity(ma)
end

-- Indicates mouse button activity, either pressed or released
function defaultcanvas.button_cb(self, but, pressed, x, y, status)
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

		Button = but;
		Clicks = clicks;
		X = x;
		Y = y;
		Delta = 0;
		KeyFlags = status;
	})

	Processing.MouseActivity(ma)
end


function defaultcanvas.wheel_cb(self, delta, x, y, status)
	local ma = MouseActivityArgs({
		Device = nil ;
		ActivityType = MouseActivityType.MouseWheel;
		ButtonActivity = MouseButtonActivity.MouseWheel;
		CoordinateSpace = MouseCoordinateSpace.Window;
		MovementType = MouseMovementType.Absolute;
		Window = self;

		Button = MouseButtonActivity.None;
		Clicks = 0;
		X = x;
		Y = y;
		Delta = delta;
		KeyFlags = status;
	})

	Processing.MouseActivity(ma)
end
