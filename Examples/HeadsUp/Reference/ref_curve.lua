function ccerp(u, cps)
	return cerp(cubic_U(u), cubic_catmullrom_M(), cubic_vec3_to_cubic_vec4(cps));
end

local pts = {
	{5,26,0},
	{5,26,0},
	{73,24,0},
	{73,61,0}
	}

function setup()
	background(53)
end

local steps = 30

function curve(x1, y1,  x2, y2,  x3, y3,  x4, y4)
	local curveSteps = 30;
	local pts = {
		{x1, y1, 0},
		{x2, y2, 0},
		{x3, y3, 0},
		{x4, y4, 0}
		}

	local lastPoint = ccerp(0, pts);
	for i=1, curveSteps do
		local u = i/steps;
		local cpt = ccerp(u, pts);
		line(lastPoint[1], lastPoint[2], cpt[1], cpt[2])
		lastPoint = cpt;
	end
end

function draw()
	noFill();
	
	stroke(255, 102, 0);
	curve(5, 26, 5, 26, 73, 24, 73, 61);
	
	stroke(0); 
	curve(5, 26, 73, 24, 73, 61, 15, 65); 
	
	stroke(255, 102, 0);
	curve(73, 24, 73, 61, 15, 65, 15, 65);
end