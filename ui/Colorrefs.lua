local bit = require "bit"

local band = bit.band
local lshift = bit.lshift
local rshift = bit.rshift

function cref(r,g,b,a)
	a = a or 255
	b = b or 0
	g = g or 0
	r = r or 0

	local value = lshift(a, 24) + lshift(r, 16) + lshift(g, 8) + b
	return value
end

function rgba(c)
	local b = band(c, 0xff)
	c = rshift(c,8)
	local g = band(c, 0xff)
	c = rshift(c,8)
	local r = band(c, 0xff)
	c = rshift(c, 8)
	local a = band(c, 0xff)

	return r,g,b,a
end

function rgbaNormalized(c)
	local r,g,b,a = rgba(c)

	return {r/255, g/255, b/255, a/255}
end

Colorrefs = {
    Black = cref(0, 0, 0);
    Red = cref(0xff, 0, 0);
    Green = cref(0, 0xff, 0);
    Blue = cref(0, 0, 0xff);
    LtGray = cref(0xc0,0xc0,0xc0);
    White = cref(0xff, 0xff, 0xff);

--[[
        public const uint
            DarkRed = 0x00000080,
            Pink = 0x00cbc0ff,
            DarkOrange = 0x00008cff,
            Tomato = 0x004763ff,
            DarkGreen = 0x00008000,
            DarkBlue = 0x00800000,
            DarkYellow = 0x00008080,
            Yellow = 0x0000ffff,
            DarkCyan = 0x00808000,
            Cyan = 0x00ffff00,
            DarkMagenta = 0x00800080,
            Magenta = 0x00ff00ff,
            Gray = 0x00bebebe,
            LightGray = 0x00d3d3d3,
            MedGray = 0x00A4A0A4,
            DarkGray = 0x00808080,
            Gray25 = 0x00404040,
            Cream = 0x00F0FBFF;
        #endregion
    }
--]]
}

return Colorrefs
