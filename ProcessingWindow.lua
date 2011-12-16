--
-- FabuWindow.lua
--
-- The primary window for BanateCAD
--
-- Copyright (c) 2011  William Adams
--

-- Global namespace


require ("iuplua")

require ("SceneViewer")

intext = iup.text({
	expand = 'YES',
	MULTILINE = 'YES',
	TABSIZE = "4",
	WORDWRAP = "YES",
	FONTFACE = "MS Shell Dlg 2",
	FONTSIZE = 8,
	})

--
viewinsplit = iup.split({
	defaultglcanvas,
	intext;
	orientation = "HORIZONTAL",
	showgrip = "FALSE",
	VALUE = "800",
})


ProcessingWindow = {}
function ProcessingWindow:new(o)
	o = o or {}		-- create object if user does not provide one

	setmetatable(o, self)
	self.__index = self

	o.Name = o.Name or "Application"
	o.menuman = MenuManager:new()
	o.window = iup.dialog({
		-- The primary content
		--mainsplit;
		viewinsplit;

		-- Initial attributes of window
		--size='HALFxHALF',
		RASTERSIZE = "1024x768",
		TITLE=o.Name,
		})

	o.menucontrol = MenuController:new({window=o})
	o.window.MENU = o.menuman:GetMainMenu(o.menucontrol)

--print("ProcessingWindow.new() - END")
	return o
end

function ProcessingWindow.Show(self)
	self.window:show();
end

function ProcessingWindow.SetFilename(self,filename)
	local name = filename or "File"

	self.window.TITLE = self.Name..' - '..name;
end


-- Dummy function for setup()
-- User script should overwrite this
function setup()
end

-- Dummy function to draw
-- The user should supply a new draw() method in their code
function draw()
	--print("ProcessingWindow - draw()")
end

function createTimer(frequency)
	aTimer = iup.timer({time=1000/frequency})
	return aTimer
end

defaultFrequency = 2
defaultTimer = createTimer(defaultFrequency)
function defaultTimer.action_cb(self)
	draw()	-- dummy function
end
