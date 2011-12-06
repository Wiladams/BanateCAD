--
-- FabuWindow.lua
--
-- The primary window for BanateCAD
--
-- Copyright (c) 2011  William Adams
--

require ("iuplua")
require ("ChatConduit")
local http = require("socket.http")
local ltn12 = require("ltn12")


intext = iup.text({
	expand = 'YES',
	MULTILINE = 'NO',
	TABSIZE = "4",
	WORDWRAP = "YES",
	FONTFACE = "MS Shell Dlg 2",
	FONTSIZE = 12,
	})

-- Capture keyboard commands
intext.Url = "http://paxosvotingservice.cloudapp.net/paxosvotingservice.svc/votes"

function intext.k_any(self, c)
	if iup.K_CR == c then
		local val = intext.VALUE

		ChatConduit.Propose(val)
		-- Clear the current input text
		intext.VALUE = ''
	end
end



outconsole = iup.text({
	expand = 'YES',
	MULTILINE = 'YES',
	TABSIZE = "4",
	WORDWRAP = "YES",
	FONTFACE = "MS Shell Dlg 2",
	FONTSIZE = 12,
	})

viewinsplit = iup.split({
	outconsole,
	intext;
	orientation = "HORIZONTAL",
	showgrip = "FALSE",
	VALUE = "800",
})


BChatWindow = {}
function BChatWindow:new(o)
	o = o or {}		-- create object if user does not provide one

	setmetatable(o, self)
	self.__index = self

	o.Name = o.Name or "Banate Chat"
	o.window = iup.dialog({
		-- The primary content
		viewinsplit;

		-- Initial attributes of window
		--size='HALFxHALF',
		RASTERSIZE = "1024x768",
		TITLE=o.Name,
		})

	return o
end



function BChatWindow.Show(self)
	self.window:show();
end

function BChatWindow.SetFilename(self,filename)
	local name = filename or "File"

	self.window.TITLE = self.Name..' - '..name;
end



-- Create the polling timer
local frequency = 1
pollingTimer = iup.timer({time=1000/frequency})
pollingTimer.run = "YES"

function pollingTimer.action_cb(self)
	ChatConduit:GetRecentVotes()
end


