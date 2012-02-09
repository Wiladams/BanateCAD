require "Collections"

local class = require "pl.class"


class.AsyncQueue(nil)

function AsyncQueue:_init(watcher)
	self.MyQueue = Queue()
	self.QueueWatcher = watcher
	self.Coroutine = coroutine.create(self.Execute)
end

function AsyncQueue.Execute(self, ...)
	while true do
		if self.QueueWatcher ~= nil then
			self.QueueWatcher(self)
		end
		coroutine.yield(self)
	end
end

function AsyncQueue.Enqueue(self, value)
	-- Put the value into the queue
	self.MyQueue:Enqueue(value)

	-- Then resume the coroutine so the Watcher
	-- can do its thing
	coroutine.resume(self.Coroutine, self)
end

function AsyncQueue.Dequeue(self)
	-- Pull an item out of the queue
	return self.MyQueue:Dequeue()
end

function AsyncQueue.Length(self)
	-- Return the length of the queue
	return self.MyQueue:Len()
end
