--
-- BanateCAD.wlua
--
-- The main interface file
-- Copyright (c) 2011  William Adams
--

require("BApplication")
require("BChatWindow")


-- Create the main window we will be using
local AppName = "Banate Chat";

-- Construct the application object
local appctx = BAppContext:new({
	Modules={
		"core",			-- Guts of the system
		"collab",		-- Collaboration Code
		}
	})

Application = BApplication:new({
	AppContext = appctx,
	Name=AppName,
	Window = BChatWindow:new({Name=AppName})
	});


-- Run the application
Application:Run();
