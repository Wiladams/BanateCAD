--
-- BanateProcessing.wlua
--
-- The main interface file
-- Copyright (c) 2011  Microsoft
--

require ("BAppContext")

-- Implementing a class structure
class = require "pl.class"

-- Create the main window we will be using
local AppName = "Banate Processing";

-- Construct the application object
local appctx = BAppContext:new({
		Modules={
			"core",
			"Processing",
		}
	})

require("BApplication")
require("ProcessingWindow")


local pWindow = ProcessingWindow:new({Name=AppName})

function pWindow.window.keypress_cb(c, press)
--print("ProcessingWindow.keypress_cb: ", c, press)
	return iup.CONTINUE;
end

function pWindow.window.close_cb(self)
	--print("ProcessingWindow.close_cb")
	-- Make sure to stop the animation
	Processing.StopAnimation()
	return iup.CLOSE
end

--print("pWindow: ", pWindow)

Application = BApplication:new({
	AppContext = appctx,
	Name=AppName,
	Window = pWindow
	});



-- Run the application
Application:Run();


