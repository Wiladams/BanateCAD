--
-- MenuManager.lua
--
-- The menu definitions for BanateCAD
-- Copyright (c) 2011  William Adams
--

require ("iuplua")

local class = require "pl.class"

class.MenuManager()
function MenuManager:_init(params)
end

function MenuManager.CreateMenu(self, templ, controller)
    local items = {}
	local item = nil

    for i = 1,#templ,2 do
        local label = templ[i]
        local data = templ[i+1]
        if type(data) == 'function' then
            item = iup.item{title = label}
            item.action = data		-- must be lowercase 'action'
        elseif type(data) == 'nil' then
            item = iup.separator{}
        else
            item = iup.submenu {self:CreateMenu(data); TITLE = label}
        end
        table.insert(items,item)
    end
    return iup.menu(items)
end

function MenuManager.GetMainMenu(self, control)
	self.controller = control;
	self.mainmenu = self:CreateMenu(self.controller:GetMenuDefinition());

	return self.mainmenu;
end

return MenuManager
