--
-- BanateCAD.wlua
--
-- The main interface file
-- Copyright (c) 2011  William Adams
--

require "BAppContext"


-- Creating the BAppContext object must be the first
-- thing done in the app as it contains various modules
-- that the other objects in the app depend on.
-- Construct the application object

local appctx = BAppContext({
	Modules={
		"physics",
		"animation",	-- Animation System
		"codec",		-- Coder/Decoder for files
		"BanateCAD",	-- For BanateCAD specifics
		"UI",
		"Solids",
		"csg",
		"Geometry",
		"core",			-- Guts of the system
		}
	})


local AppName = "Banate CAD";

require("BApplication")
require("BWindow")
require "BCADLanguage"

Application = BApplication({
	AppContext = appctx,
	Name=AppName,
	Window = BWindow({Name=AppName})
	});



-- Run the application
Application:Run();
