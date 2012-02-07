-- MenuController.lua
--
-- Copyright (c) 2011  William Adams
--
-- Menu commands for BanateCAD
--

require "iuplua"

require "HeadsUpMenuCommands"
require "HeadsUpMenuDef"

local class = require "pl.class"
local pather = require "pl.path"

class.HeadsUpMenuControl()

function HeadsUpMenuControl:_init(o)
	o = o or {}		-- create object if user does not provide one

	self.Window = o.Window
end

--==============================================
--	MENU DEFINITION
--==============================================

function HeadsUpMenuControl.GetMenuDefinition(self)
	return HeadsUpMenuDef
end
