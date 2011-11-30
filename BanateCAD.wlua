--
-- BanateCAD.wlua
--
-- The main interface file
-- Copyright (c) 2011  William Adams
--

require("BApplication")
require("BWindow")


-- Create the main window we will be using
local AppName = "Banate CAD";

-- Construct the application object
local appctx = BAppContext:new({
	Modules={"core"}
	})

Application = BApplication:new({
	AppContext = appctx,
	Name=AppName,
	Window = BWindow:new({Name=AppName})
	});


-- Run the application
Application:Run();
