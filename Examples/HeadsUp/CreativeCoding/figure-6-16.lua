size(300, 300)

background(0);
stroke(255);

local cellwidth = width/30;
local val = cellwidth*(255/width);

-- Vertical Lines
local v = 255
for i = cellwidth, width-1, cellwidth do
	stroke(v)
	for j=0, height-1 do
		point(i,j)
	end
	v = v-val
end