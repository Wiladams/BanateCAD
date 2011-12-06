--
-- BanateCAD.wlua
--
-- The main interface file
-- Copyright (c) 2011  William Adams
--

require ("BAppContext")

-- Create the main window we will be using
local AppName = "Banate Chat";

-- Construct the application object
local appctx = BAppContext:new({
	Modules={
		"core",			-- Guts of the system
		"collab",		-- Collaboration Code
		}
	})

require("BApplication")
require("BChatWindow")
require ("ChatConduit")
local http = require("socket.http")
local ltn12 = require("ltn12")

Application = BApplication:new({
	AppContext = appctx,
	Name=AppName,
	Window = BChatWindow:new({Name=AppName})
	});


-- Setup the communications conduit
-- Setup the ChatConduit
ChatConduit.LastVote = 30

-- Get initial set of votes
--ChatConduit.GetRecentVotes()

-- Run the application
Application:Run();
