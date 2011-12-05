DequeuePrintFunctor={}
DequeuePrintFunctor_mt = {}

function DequeuePrintFunctor.new(...)
	local new_inst = {}

	setmetatable(new_inst, DequeuePrintFunctor_mt)

	return new_inst
end

function DequeuePrintFunctor.Execute(t, aqueue)
	if aqueue ~= nil  and aqueue:Length() > 0 then
		local val = aqueue:Dequeue()
		-- Do whatever we are going to do with
		-- the dequeued value, like hand it to someone
		-- else to deal with
		print(val)
	else
		print("DequeuePrintFunctor.Execute - Nothing to Dequeue")
	end
end

DequeuePrintFunctor_mt.__call = DequeuePrintFunctor.Execute;
