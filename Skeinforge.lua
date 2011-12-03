--
-- Skeinforge.lua
--
-- Copyright (c) 2011  Remco Schoeman
--
-- integrates Skeinforge into BanateCAD
--

require ("iuplua")
require ("lfs")
require("Options")

--============================
-- Constants
--============================

local optionsFile = "Skeinforge.options"
local python = 'start /B python'
local pythonw = 'start /B pythonw'
local dirsep = package.config:sub(1,1) -- hacky way to get the system directory separator

--============================
-- Skeinforge entry point
--============================

Skeinforge = {}

-- loads options from the default options file
function Skeinforge.loadOptions(self)
	local filename = optionsFile
	local file, e =  io.open(filename) -- check if file exists.
	local opts
	if file then
		file:close() -- close it again.
		opts = Options.load(filename)
	else
		local defaults =
		{
			lastStlFile = nil,
			skeinforgePath = nil,
			profiles = {"Pla","Abs", selectedProfile = "Pla",},
		}
		-- save default configuration
		Options.save(defaults, filename)
		-- load options object
		opts = Options.load(filename)
	end
	self.Options = opts
end

-- function that discovers the available profiles from skeinforge itself
-- returns a list of profile names.
function Skeinforge.askUserForInstallPath(self)
	local fileDialog = iup.filedlg{
		dialogtype = "OPEN",
		title = "Locate Skeinforge",
		extfilter = "Skeinforge Application|skeinforge.py|",
		}
	fileDialog.value = self:getSkeinforgePath() or ".",
	fileDialog:popup()
	local skeinforge = fileDialog.value
	local directory = fileDialog.directory
	fileDialog:destroy()

	if skeinforge then
		self.Options.skeinforgePath = directory
		self.Options:save()
	end
	return skeinforge
end

-- runs Skeinforge itself
function Skeinforge.configure(self, wait)
	local skeinforge = self:getSkeinforgePath() or self:askUserForInstallPath()
	if skeinforge then
		local cmd = pythonw .. ' "' .. skeinforge .. '"'
		local result = os.execute(cmd)
	end
end

-- runs Skeinforge on a selected stl file
function Skeinforge.slice(self)
	local skeinforge = self:getSkeinforgePath() or self:askUserForInstallPath()

	local fileDialog = iup.filedlg{
		dialogtype="OPEN",
		title="Select STL File",
		extfilter="Stl file|*.stl|",
		}
	fileDialog.value = self.Options.lastStlFile or "."
	fileDialog:popup()
	local stlfile = fileDialog.value
	fileDialog:destroy()

	if skeinforge and stlfile then
		self.Options.lastStlFile = stlfile
		self.Options:save()
		local cmd = python .. ' "' .. skeinforge  .. '" "' .. stlfile .. '"'
		local result = os.execute(cmd)
	end
end

function Skeinforge.getSkeinforgePath(self)
	local path = self.Options.skeinforgePath;
	if path then
		return self.Options.skeinforgePath .. "skeinforge.py"
	else
		return nil
	end
end

-- initialize options
Skeinforge:loadOptions()

--[[ quick testing code
python = 'start python'
pythonw = 'start pythonw'
Skeinforge:slice()
--]]
