require ("Collections")

---[[
local al = List.new()
al:pushright(1)
al:pushright(2)
al:pushright(3)

print("LIST")
print(al:popleft())
print(al:popleft())
print(al:popleft())
--]]

---[[
local aq = queue.new()
aq:enqueue(1)
aq:enqueue(2)
aq:enqueue(3)

print("QUEUE")
print(aq:dequeue())
print(aq:dequeue())
print(aq:dequeue())
--]]
