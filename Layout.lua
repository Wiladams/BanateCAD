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
function Layout:reloadOptions()
	self.Options = nil;
	self:update()
end

-- loads options from the default options file
function Layout:loadOptions()
	local filename = optionsFile
	local file, e = io.open(filename) -- check if file exists.
	if file then
		file:close() -- close it again.
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
				foreground = "0 128 0",
				background = "0 0 0",
			},
		}
		Options.save(defaults, filename)
	end
	self.Options = Options.load(filename)
	return self.Options
end

-- shows the editor options editor
function Layout:showEditorOptions()
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
function Layout:showConsoleOptions()
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
function Layout:updateEditor()
	self.editor.fgcolor = self.Options.editor.foreground
	self.editor.bgcolor = self.Options.editor.background
	self.editor.font = self.Options.editor.font
end

-- updates console properties from the current options
function Layout:updateConsole()
	self.console.fgcolor = self.Options.console.foreground
	self.console.bgcolor = self.Options.console.background
	self.console.font = self.Options.console.font
end

-- updates all ui element with the current options.
function Layout:update()
	if not self.Options then
		self:loadOptions()
	end
	self:updateEditor()
	self:updateConsole()
end

--============================
-- UI layout construction
--============================

Layout:loadOptions()

intext = iup.text({
	expand = 'YES',
	MULTILINE = 'YES',
	TABSIZE = "4",
	WORDWRAP = "YES",
	FONT = Layout.Options.editor.font,
	FGCOLOR = Layout.Options.editor.foreground,
	BGCOLOR = Layout.Options.editor.background,
	})

outconsole = iup.text({
	expand = 'YES',
	MULTILINE = 'YES',
	TABSIZE = "4",
	WORDWRAP = "YES",
	FONT = Layout.Options.console.font,
	FGCOLOR = Layout.Options.console.foreground,
	BGCOLOR = Layout.Options.console.background,
	})

iosplit = iup.split({
	intext,
	outconsole;
	orientation = "HORIZONTAL",
	showgrip = "FALSE",
	VALUE = "HALF",
})

viewinsplit = iup.split({
	defaultglcanvas,
	iosplit;
	orientation = "HORIZONTAL",
	showgrip = "FALSE",
	VALUE = "800",
})

Layout.canvas = defaultglcanvas
Layout.editor = intext
Layout.console = outconsole
Layout.console.value = "Banate CAD\n"
