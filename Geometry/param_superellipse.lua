--require ("Class")

function sign(n)
	if n < 0 then
		return -1
	end
	return 1
end

param_superellipse = inheritsFrom(nil)
function param_superellipse.new(params)
	local new_inst = param_superellipse.create()

	new_inst.XRadius = params.XRadius or 1
	new_inst.ZRadius = params.ZRadius or 1
	new_inst.N = params.N or 1

	return new_inst
end

function param_superellipse.GetProfileVertex(self, u)
	local angle = u*2*math.pi
	cangle = math.cos(angle)
	sangle = math.sin(angle)

	local tmp = sign(cangle) * math.pow(math.abs(cangle), self.N)
	local x = self.XRadius * tmp
	local y = self.XRadius * tmp
	local z = self.ZRadius * sign(sangle)*math.pow(math.abs(sangle), self.N)
	return {x,y,z}
end
