OSubject={}
function OSubject:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	Observers={}

	return o
end

function OSubject.Publish(self, msg)
	for _,observer in ipairs(self.Observers) do
		observer:ReceiveMessage(msg);
	end
end

function OSubject.AddObserver(self, observer)
	table.insert(self.Observers, observer);

end

function OSubject.RemoveObserver(self, observer)
end



