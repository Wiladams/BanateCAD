local width = 300
local height = 300

local totalPts = 300
local steps = totalPts + 1

function setup()
	-- size(300,300)
	background(0)

	stroke(255)

	for i=1, steps do
		point((width/steps)*i, (height/2)+random(-2,2));
	end
end
