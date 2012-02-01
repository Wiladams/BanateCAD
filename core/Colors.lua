local Color = require "Color"

Colors = {
	Transparent = Color(0,0,0,0),

	Black = Color(0,0,0, 255),

	BrightOrange 	= Color(245, 100, 0),	-- (#f56400)
	MediumOrange 	= Color(122, 49, 0),	-- (#7a3100)
	DarkOrange		= Color(94, 38, 0),		-- (#5e2600)
	Brown			= Color(78, 56, 47),	-- (#4e382f), (nav bar and footer)

	Red = Color(0xff, 0,0, 255),
	Green = Color(0, 0xff, 0, 255),
	Blue = Color(0, 0, 0xff, 255),
	Yellow = Color(0xff, 0xff, 0, 255),
	Purple = Color(0x80, 0, 0x80, 255),
	Fuschia = Color(0xff, 0, 0xff, 255),
	Navy = Color(0, 0, 0x80, 255),
	Teal = Color(0, 0x80, 0x80, 255),
	Aqua = Color(0, 0xff, 0xff, 255),
	Olive = Color(0x80, 0x80, 0, 255),
	Lime = Color(0, 0xff, 0, 255),

	Silver = Color(0, 0x80, 0, 255),

	LtGray = Color(0xc0,0xc0,0xc0, 255),
	DarkGray = Color(0x80, 0x80, 0x80, 255),

	aliceblue = Color(240, 248, 255),
	antiquewhite = Color(250, 235, 215),
	aqua = Color(0, 255, 255),

	White = Color(255,255,255,255),
}



return Colors
