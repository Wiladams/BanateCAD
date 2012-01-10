local Color = require "Color"

Colors = {
	Transparent = Color(0,0,0,0),

	Black = Color(0,0,0, 255),

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

	White = Color(255,255,255,255),
}



return Colors
