require ("Class")

-- The basic list time
-- This will be used to implement queues

List = inheritsFrom(nil)
function List.new ()
	local new_inst = List.create()
	new_inst.first = 0
	new_inst.last = -1

	return new_inst
end

function List.init(self)
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



queue = inheritsFrom(nil)
function queue.new()
	local new_inst = queue.create()

	new_inst.MyList = List.new()
	return new_inst
end

function queue.enqueue(self, value)
	self.MyList:pushright(value)
end

function queue.dequeue(self, value)
	return self.MyList:popleft()
end

function queue.len(self)
	return self.MyList.last - self.MyList.first+1
end

