--size(300, 300)
width = 300;
height = 300;

local cellwidth = width/30;
local cellheight = height/30;

background(0);

stroke(255);

-- Vertical Lines
for i = cellwidth, width-1, cellwidth do
	for j=0, height-1 do
		point(i,j)
	end
end

-- Horizontal Lines
for i=cellheight, height-1, cellheight do
	for j=0, width-1 do
		point(j,i)
	end
end
