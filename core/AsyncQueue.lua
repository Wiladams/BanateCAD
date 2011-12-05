--require("Class")
--require("Collections")

AsyncQueue = inheritsFrom(nil)

function AsyncQueue.new(watcher)
	new_inst = AsyncQueue.create()

	new_inst.Queue = queue.new()
	new_inst.QueueWatcher = watcher
	new_inst.Coroutine = coroutine.create(new_inst.Execute)

	return new_inst
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
	self.Queue:enqueue(value)

	-- Then resume the coroutine so the Watcher
	-- can do its thing
	coroutine.resume(self.Coroutine, self)
end

function AsyncQueue.Dequeue(self)
	-- Pull an item out of the queue
	return self.Queue:dequeue()
end

function AsyncQueue.Length(self)
	-- Return the length of the queue
	return self.Queue:len()
end
