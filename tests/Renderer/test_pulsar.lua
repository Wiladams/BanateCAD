class.Tracker()

function Tracker:_init(x, y)
	self.centerx = x
	self.centery = y
	self.TickCount = 0
end

function Tracker.Render(self, renderer)
	local txt = tostring(self.TickCount)
	fill(0)
	stroke(0)
	text(self.centerx, self.centery, txt)
end

function Tracker.Update(self, tickCount)
	self.TickCount = tickCount
end

class.Pulsar()
function Pulsar:_init()
	self.InnerRadius = 45
	self.OuterRadius = 50
	self.centerx = 200
	self.centery = 200
	self.Tick = 0
	self.ModTick = 10
end

function Pulsar.Update(self, tickCount)
	self.Tick = mod(tickCount, self.ModTick)
end

function Pulsar.Render(self, renderer)
	local radius = map(self.Tick, 0,self.ModTick, self.InnerRadius, self.OuterRadius)
	noStroke()
	fill(230, 32, 32)
	ellipse(self.centerx, self.centery, radius, radius)

	stroke(0)
	strokeWeight(1)
	fill(255)
	ellipse(self.centerx, self.centery, self.InnerRadius, self.InnerRadius)
end


local tracker1 = Tracker(10,20)
local pulsar1 = Pulsar();

addactor(tracker1);
addactor(pulsar1);

function draw()
	background(230)
end