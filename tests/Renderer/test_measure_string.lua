background(230)

local fnt = GFont("Courier", " ", 24);
local txt1 = "Text";


local fntsize = fnt:MeasureString(txt1)

local sizestr = string.format("{%d, %d}", fntsize[1], fntsize[2])

local label1 = GText("Size:", {10, 20})
local label2 = GText(sizestr, {100, 20})

addgraphic(label1) 
addgraphic(label2)

function draw()
	background(230)
end
