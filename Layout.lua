--
-- Layout.lua
--
-- The layout for BanateCAD
-- Copyright (c) 2011  William Adams
--

require ("iuplua")
require ("SceneViewer")
require ("Options")

--============================
-- Constants
--============================

local optionsFile = "Layout.options"

--============================
-- Layout entry point
--============================

Layout = {}

--============================
-- UI manipulation
--============================

-- clears and reloads layout options
function Layout.reloadOptions(self)
	self.Options = nil;
	self:update()
end

-- loads options from the default options file
function Layout.loadOptions(self)
	local filename = optionsFile
	local file, e =  io.open(filename) -- check if file exists.
	local opts
	if file then
		file:close() -- close it again.
		opts = Options.load(filename)
	else
		local defaults =
		{
			editor =
			{
				font = "Courier New, 10",
				foreground = "0 0 0",
				background = "255 255 255",
			},
			console =
			{
				font = "Courier New, 10",
				foreground = "0 0 0",
				background = "255 255 255",
			},
		}
		-- save default configuration
		Options.save(defaults, filename)
		-- load options object
		opts = Options.load(filename)
	end
	self.Options = opts
end

-- shows the editor options editor
function Layout.showEditorOptions(self)
	local opts = self.Options
	local result,
		editorfont,
		editorforeground,
		editorbackground
		= iup.GetParam(
		"Editor Options", nil,
		"Font %n\n"..
		"Foreground %c{Color Tip}\n"..
		"Background %c{Color Tip}\n",
		opts.editor.font,
		opts.editor.foreground,
		opts.editor.background, nil
		)

	if result then
		opts.editor.font = editorfont
		opts.editor.foreground = editorforeground
		opts.editor.background = editorbackground
		opts:save()
		self:updateEditor()
	end
end

-- shows the console options editor
function Layout.showConsoleOptions(self)
	local opts = self.Options
	local result,
		consolefont,
		consoleforeground,
		consolebackground
		= iup.GetParam(
		"Console Options", nil,
		"Font %n\n"..
		"Foreground %c{Color Tip}\n"..
		"Background %c{Color Tip}\n",
		opts.console.font,
		opts.console.foreground,
		opts.console.background, nil
		)

	if result then
		opts.console.font = consolefont
		opts.console.foreground = consoleforeground
		opts.console.background = consolebackground
		opts:save()
		self:updateConsole()
	end
end

-- updates editor properties from the current options
function Layout.updateEditor(self)
	self.editor.fgcolor = self.Options.editor.foreground
	self.editor.bgcolor = self.Options.editor.background
	self.editor.font = self.Options.editor.font
end

-- updates console properties from the current options
function Layout.updateConsole(self)
	self.console.fgcolor = self.Options.console.foreground
	self.console.bgcolor = self.Options.console.background
	self.console.font = self.Options.console.font
end

-- updates all ui element with the current options.
function Layout.update(self)
	if not self.Options then
		self:loadOptions()
	end
	self:updateEditor()
	self:updateConsole()
end

--============================
-- UI layout construction
--============================

intext = iup.text({
	expand = 'YES',
	MULTILINE = 'YES',
	TABSIZE = "4",
	WORDWRAP = "YES",
	FONTFACE = "MS Shell Dlg 2",
	FONTSIZE = 8,
	})

outconsole = iup.canvas({
	EXPAND = "YES"
	})

viewinsplit = iup.split({
	defaultglcanvas,
	intext;
	orientation = "HORIZONTAL",
	showgrip = "FALSE",
	VALUE = "800",
})

Layout.canvas = defaultglcanvas
Layout.editor = intext
Layout.console = outconsole

-- load and apply options
Layout:update()
