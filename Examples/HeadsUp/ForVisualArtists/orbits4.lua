class.HeavenlyBody()
function HeavenlyBody:_init(diam, orbit, acolor)
	self.Diameter = diam;
	self.Orbit = orbit
	self.Angle = 0
	self.Color = acolor
end

function HeavenlyBody.Render(self)
	rotate(self.Angle);
	translate(self.Orbit, 0);
	noStroke();
	fill(self.Color);
	ellipse(0,0,self.Diameter, self.Diameter)
end

local Sun = HeavenlyBody(80, 0, color(255, 200, 64))
local Earth = HeavenlyBody(30, 130, color(64, 64, 255))
local Moon = HeavenlyBody(10, 50, color(192,192,180))
local Nem = HeavenlyBody(20, 40, color(220,75,75))

function setup()
	size(1024, 768);
	background(0);

	-- Translate origin to center of screen
	translate(width/2, height/2);

end

function draw()
	background(0);

	--pushMatrix();

	Sun:Render();

	Earth:Render();
	pushMatrix();

	Moon:Render();
	popMatrix();

	Earth.Angle = Earth.Angle + radians(1);
	Moon.Angle = Moon.Angle + 0.4;

	--popMatrix();
end