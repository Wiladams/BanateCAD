--
-- BanateCAD.wlua
--
-- The main interface file
-- Copyright (c) 2011  William Adams
--

require ("BAppContext")


-- Creating the BAppContext object must be the first
-- thing done in the app as it contains various modules
-- that the other objects in the app depend on.
-- Construct the application object
local appctx = BAppContext:new({
	Modules={
		"core",			-- Guts of the system
		"Geometry",
		"UI",
		"csg",
		"BanateCAD",	-- For BanateCAD specifics
		"codec",		-- Coder/Decoder for files
--		"collab",		-- Collaboration Code
		"animation",	-- Animation System
		"physics",
		}
	})

local AppName = "Banate CAD";

--require("BGameApplication")
require("BApplication")
require("BWindow")


Application = BApplication:new({
--Application = BGameApplication:new({
	AppContext = appctx,
	Name=AppName,
	Window = BWindow:new({Name=AppName})
	});



-- Run the application
Application:Run();
