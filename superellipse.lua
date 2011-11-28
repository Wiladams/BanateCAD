require ("Class")

param_superellipse = inheritsFrom(nil)
function param_superellipse.new(params)
	local new_inst = param_superellipse.create()

	self.XRadius = params.XRadius or 1
	self.ZRadius = params.ZRadius or 1
	self.N = params.N or 1

	return new_inst
end

function param_superellipse.GetProfileVertex(self, u)
	local angle = u*self.MaxTheta

	local x = self.XRadius*math.pow(math.sin(angle), self.N)
	local y = x
	local z = self.ZRadius*math.pow(math.cos(angle), self.N)

	return {x,y,z}
end
