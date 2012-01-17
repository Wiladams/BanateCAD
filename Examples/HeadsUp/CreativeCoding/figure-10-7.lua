size(500, 300)
background(255)
strokeWeight(0.2)
smooth();
noFill();

local radius = 0;
local thickness = 0.35;
local x = 0;
local y = height/2;
local amp = 0.5;
local angle = 0;

for i=1, width-1 do
	stroke(65, 10, 5);
	translate(2,y);
	ellipse(-radius/2, -radius/2, radius*.75, radius);
	y = sin(radians(angle))*amp;
	angle = angle + 5;
	radius = radius + thickness;
	if i == width/4 then
		thickness = thickness*-1
	end
end
