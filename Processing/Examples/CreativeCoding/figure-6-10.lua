--size(300, 300)
width = 300;
height = 300;

background(0);
local cellwidth = width/30;
stroke(255);

-- Vertical Lines
for i = cellwidth, width-1, cellwidth do
	for j=0, height-1 do
		point(i,j)
	end
end
