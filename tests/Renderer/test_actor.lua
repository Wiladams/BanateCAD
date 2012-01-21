class.Tracker()

function Tracker:_init(x, y)
	self.centerx = x
	self.centery = y
	self.TickCount = 0
end

function Tracker.Render(self, renderer)
	local txt = tostring(self.TickCount)
	text(self.centerx, self.centery, txt)
end

function Tracker.Update(self, tickCount)
	self.TickCount = tickCount
end

class.Pulsar()
function Pulsar:_init()
	self.centerx = 200
	self.centery = 200
	self.Tick = 0
	self.ModTick = 5
end

function Pulsar.Update(self, tickCount)
	self.Tick = mod(tickCount, self.ModTick)
end

function Pulsar.Render(self, renderer)
	--text(self.centerx, self.centery, tostring(sinangle))

	local radius = map(self.Tick, 0,self.ModTick, 30, 50)
	ellipse(self.centerx, self.centery, radius, radius)
end


local tracker1 = Tracker(10,20)
local pulsar1 = Pulsar();

addactor(tracker1);
addactor(pulsar1);

function draw()
	background(230)
	--tracker1:Render()
end