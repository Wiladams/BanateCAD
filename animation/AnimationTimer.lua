require ("iuplua")

-- Create a base class, AnimationTimer
--[[
AnimationTimer = inheritsFrom(nil);
Timers={}
function AnimationTimer.new(params)
	params = params or {}		-- create object if user does not provide one

	local new_inst = AnimationTimer.create()

	params.Frequency = params.Frequency or 1
	params.Tick = params.Tick or 0

	new_inst.Frequency = params.Frequency
	new_inst.Tick = 0
	new_inst.Timer = iup.timer({time=1000/params.Frequency})
	new_inst.Timer.action_cb = new_inst.action_cb

	return new_inst
end
--]]

function createTimer(frequency)
	aTimer = iup.timer({time=1000/frequency})
	return aTimer
end

defaultFrequency = 5
defaultTimer = createTimer(defaultFrequency)

AnimationTimer = {TickCount=0, Frequency=2}
function AnimationTimer.Start(self)
print("Start Timer")
	defaultTimer.run = "YES"
	self.IsRunning = true
end

function AnimationTimer.Stop(self)
print("Stop Timer")
	defaultTimer.run = "NO"
	self.IsRunning = false
	self:Reset()
end

function AnimationTimer.SetFrequency(self, frequency)
	-- Stop the current Timers
	self:Stop()
	self.Frequency = frequency

	-- create a new timer with the given frequency
	defaultTimer = createTimer(frequency)

	if self.IsRunning then
		self:Start()
	end
end

function AnimationTimer.Tick(self)
--print("AnimationTimer.Tick")
	self.TickCount = self.TickCount + 1
	defaultscene:Update(self.TickCount)
	iup.Update(defaultglcanvas);
end

function AnimationTimer.Reset(self)
	self.TickCount = 0
end


function defaultTimer.action_cb(self)
	AnimationTimer:Tick()
end


