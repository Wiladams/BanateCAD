Alignment =
{
	None	= 0,
	Left	= 0x01,
	Center	= 0x02,
	Right	= 0x04,
	Top 	= 0x10,
	Middle	= 0x20,
	Bottom	= 0x40
}

--
-- The Position enum is a combination of the alignments
--
Position =
{
--[[
	TopLeft 	= 0x07,
	Top 		= 0x08,
	TopRight 	= 0x09,
	Left 		= 0x04,
	Center 		= 0x05,
	Right 		= 0x06,
	BottomLeft 	= 0x01,
	Bottom 		= 0x02,
	BottomRight = 0x03,
--]]
	TopLeft = Alignment.Top + Alignment.Left,
	Top = Alignment.Top + Alignment.Center,
	TopRight = Alignment.Top + Alignment.Right,

	Left = Alignment.Left + Alignment.Middle,
	Center = Alignment.Center + Alignment.Middle,
	Right = Alignment.Right + Alignment.Middle,

	BottomLeft = Alignment.Bottom + Alignment.Left,
	Bottom = Alignment.Bottom + Alignment.Center,
	BottomRight = Alignment.Bottom + Alignment.Right,
}


Direction =
{
	LeftRight = 0,
	RightLeft = 1,
	TopBottom = 2,
	BottomTop = 3,
}

Orientation =
{
	Vertical = 1,
	Horizontal = 2,
}


---[[
print(Alignment.Left, Alignment.Center, Alignment.Right)
--]]
