local NumPoints = 6;

local Xp = {};
local Yp = {};

function setup() 
	size(1024, 768);
   
	background(194, 216, 242);
	stroke(0)   
	noFill();
   
	for  i=1, NumPoints do 
		Xp[i] = random(100, 500);      
		Yp[i] = random(100, 300);
	end
end

function draw() 
	for i=1, NumPoints do
		ellipse(Xp[i], Yp[i], 10, 10);
	end
end