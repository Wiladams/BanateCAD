--size(300, 300)
width = 300;
height = 300;

local cellwidth = width/20;
local cellheight = height/20;
local ptGap = 3;
local randHt  = 4;
local randWdth = 10;

background(0);
stroke(255);

-- Vertical Lines
for i = cellwidth, width-1, cellwidth+random(randWdth) do
	for j=0, height-1, ptGap do
		point(i,j)
	end
end

-- Horizontal Lines
for i=cellheight, height-1, cellheight+random(randHt) do
	for j=0, width-1, ptGap do
		point(j,i)
	end
end
