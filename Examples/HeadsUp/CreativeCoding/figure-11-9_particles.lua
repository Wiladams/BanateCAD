-- Simple Motion Physics II
local shapes = 400

-- controls rate rects are born
local shapeCount = 0;
local birthRate = 3

-- control width of spray when rects are born
local sprayWidth = 2;

class.Particle()

function Particle:_init()
	self.w = random(2,6)
	self.h = self.w
	self.x = random(width-self.w)
	self.y = 0
	self.lum = random(127,255)
	self.xSpeed = random(-sprayWidth, sprayWidth);
	self.ySpeed = 0
	self.gravity = 0.1
	self.damping = random(0.2, 0.3)
	self.friction = random(0.65, 0.95);

	return self
end

function Particle:Recycle()
	self.x = random(width - self.w)
	self.y = 0
	self.xSpeed = random(-sprayWidth, sprayWidth);
	self.ySpeed = 0
end

function Particle:Render()
	fill(self.lum)
	rect(self.x, self.y,self.w, self.h);
end

function Particle:Update()
	self.x = self.x + self.xSpeed;
	self.ySpeed = self.ySpeed + self.gravity;
	self.y = self.y + self.ySpeed;

	-- Collision detection
	if self.y >= height - self.h then
		self.y = height - self.h
		
		-- bounce
		self.ySpeed = - self.ySpeed

		-- slow down vertical motion on ground collisions
		self.ySpeed = self.ySpeed * self.damping

		-- slow down lateral motioin on ground collision
		self.xSpeed = self.xSpeed * self.friction;
	end

	-- If it bounces too high
	if self.y <=0 then
		self.y = 0
		self.ySpeed = -self.ySpeed
	end

	-- Contain side to side
	if self.x >= width - self.w then
		self.x = width - self.w;
		self.xSpeed = -self.xSpeed
	end

	if self.x <= 0 then
		self.x = 0;
		self.xSpeed = -self.xSpeed
	end

	-- If the particle is sitting at the bottom with 
	-- no movement, then recycle it 
	if abs(self.xSpeed) < self.friction then
		self:Recycle()
	end
end


local particles = {}

function setup()
frameRate(40)
	size(400, 400);
	noStroke();

	-- initialize arrays with random values
	for i=1,shapes do
		table.insert(particles, Particle())		
	end
end





function draw()
	fill(55, 100);
	rect(0,0, width, height);

	-- shapeCount births rects over time
	for i=1, shapeCount do
		particles[i]:Render()
		
		particles[i]:Update()
	end

	if shapeCount < shapes then
		shapeCount = shapeCount + birthRate
		if shapeCount > shapes then
			shapeCount = shapes
		end
	end
end