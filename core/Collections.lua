-- Collections.lua

local class = require "pl.class"


-- The basic list type
-- This will be used to implement queues and other things

class.List()

function List:_init(params)
	self.first = 0
	self.last = -1
end

function List.pushleft (list, value)
	local first = list.first - 1
	list.first = first
	list[first] = value
end

function List.pushright (list, value)
	local last = list.last + 1
	list.last = last
	list[last] = value
end

function List.popleft (list)
	local first = list.first

	if first > list.last then
		error("list is empty")
	end
	local value = list[first]
	list[first] = nil        -- to allow garbage collection
	list.first = first + 1
	return value
end

function List.popright (list)
	local last = list.last
	if list.first > last then
		error("list is empty")
	end
	local value = list[last]
	list[last] = nil         -- to allow garbage collection
	list.last = last - 1
	return value
end



class.Queue()
function Queue:_init(params)
	self.MyList = List()
end

function Queue.Enqueue(self, value)
	self.MyList:pushright(value)
end

function Queue.Dequeue(self, value)
	return self.MyList:popleft()
end

function Queue.Len(self)
	return self.MyList.last - self.MyList.first+1
end

