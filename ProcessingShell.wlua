--
-- BanateProcessing.wlua
--
-- The main interface file
-- Copyright (c) 2011  Microsoft
--


require ("BAppContext")

-- Create the main window we will be using
local AppName = "Banate Processing";

-- Construct the application object
local appctx = BAppContext:new({
		Modules={
			"core",
			"Processing",
		}
	})

require("BGameApplication")
require("ProcessingWindow")

local pWindow = ProcessingWindow:new({Name=AppName})
--print("pWindow: ", pWindow)

Application = BGameApplication:new({
	AppContext = appctx,
	Name=AppName,
	Window = pWindow
	});



-- Run the application
Application:Run();
