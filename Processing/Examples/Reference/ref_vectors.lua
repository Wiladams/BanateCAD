-- Creating an array of objects.
local nMovers = 20;
local movers = {}


function setup()
  size(800,600);
  smooth();
  background(255);
  -- Initializing all the elements of the array
  for i = 1, nMovers do
    movers[i] = Mover();
  end
end

function draw()
  noStroke();
  fill(255,10);
  rect(0,0,width,height);

  -- Calling functions of all of the objects in the array.
  for i,mover in ipairs(movers) do
    mover:update();
    mover:checkEdges();
    mover:display();
  end
end

class.Mover()

function Mover:_init()
	self.location = Vector3D.new(random(width),random(height),0);
    self.velocity = Vector3D.new(0,0,0);
	self.acceleration = Vector3D.new(0,0,0);
    self.topspeed = 4;
end

function limit(vec, lim)
	local x = constrain(vec[1], -4, 4)
	local y = constrain(vec[2], -4, 4)
	local z = 0

	vec[1] = x;
	vec[2] = y;
	vec[3] = z;
end

function Mover:update()
    -- Our algorithm for calculating acceleration:
    local mouse = Vector3D.new(mouseX,mouseY,0);
    local dir = mouse - self.location;  -- Find vector pointing towards mouse
    dir = dir:unit();     -- Normalize
    dir = dir * 0.5;       -- Scale
    self.acceleration = dir;  -- Set to acceleration

    -- Motion 101!  Velocity changes by acceleration.  Location changes by velocity.
    self.velocity = self.velocity + self.acceleration;
	limit(self.velocity, self.topspeed)
    self.location = self.location + self.velocity;
end

function Mover:display()
    stroke(0);
    fill(175);
    ellipse(self.location.x,self.location.y,16,16);
end

function Mover:checkEdges()
    if (self.location.x > width) then
      self.location.x = 0;
    elseif (self.location.x < 0) then
      self.location.x = width;
    end

    if (self.location.y > height) then
      self.location.y = 0;
    elseif (self.location.y < 0) then
      self.location.y = height;
    end
end