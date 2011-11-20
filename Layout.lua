--
-- Layout.lua
--
-- The layout for BanateCAD
-- Copyright (c) 2011  William Adams
--

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

outconsole = iup.canvas({
	EXPAND = "YES"
	})




--
viewinsplit = iup.split({
	defaultglcanvas,
	intext;
	orientation = "HORIZONTAL",
	showgrip = "FALSE",
	VALUE = "800",
})

--[[
outsplit = iup.split({
	defaultglcanvas,
	outconsole;
	orientation = "HORIZONTAL",
	showgrip = "FALSE",
	VALUE = "800",
})

mainsplit = iup.split({
	intext,
	outsplit;
	color = "192 192 192",
	orientation = "VERTICAL",
	showgrip = "FALSE",
	VALUE = "300",
})
--]]
