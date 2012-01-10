require("000Class")
require("002Collections")
require("AsyncQueue")
require ("DequeuePrintFunctor")

-- Test Case

-- First create a functor, which will simply
-- take items out of the queue and print their value
local aFunctor = DequeuePrintFunctor.new()

-- Now create a queue
local aQueue = AsyncQueue.new(aFunctor)


-- Put some items into the queue
-- As quickly as they are put into the queue,
-- The DequeueFunc should be taking them out,
-- and printing their value
for i = 1, 10 do
	aQueue:Enqueue(i)
end

-- Just check to see the length of the Queu
-- in the end.  It should be zero.  If not,
-- we could loop until it was, to ensure it
-- was drained out.
print("aQueue:Length() - ", aQueue:Length())

