local width = 300;
local height = 300;

local totalPts = 300;
local steps = totalPts + 1;
local rand = 0;

function setup()
	-- size(300,300);
	background(0);

	stroke(255);
end

function draw()
	stroke(mod(frameCount, 255))
	rand=0
	for i=1, steps do
		local x = (width/steps)*i
		local y = (height/2)+random(-rand,rand)
		point(x, y);
		rand = rand + random(-5,5);
	end
end