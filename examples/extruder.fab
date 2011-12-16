-- a square
local profile1 = param_superellipse.new({
	XRadius = 6,
	ZRadius = 8,
	N = 4,
	})

-- a square
local profile2 = param_superellipse.new({
	XRadius = 10,
	ZRadius = 10,
	N = 1,
	})

-- A circle
local profile3 = param_superellipse.new({
	XRadius = 8,
	ZRadius = 8,
	N = 1,
	})

local profiler = inheritsFrom(BiParametric)

function profiler.new(params)
	local new_inst = profiler.create()

	new_inst.Profiles = params.Profiles or {}
	--new_inst.Profile1 = params.Profile1
	--new_inst.Profile2 = params.Profile2
	new_inst.Height = params.Height

	new_inst.USteps = params.USteps or 10
	new_inst.WSteps = params.WSteps or 10
	new_inst.Thickness = params.Thickness

	return new_inst
end


function profileselector(range, w)
	local y = 1 + math.floor(w*range)

	if y > range then
		y = y-1
	end

	return y
end

function profiler.SelectProfiles(self, u,w)
	local profile1 = nil
	local profile2 = nil

	if #self.Profiles == 1 then
		profile1 = self.Profiles[1]
		profile2 = self.Profiles[1]
	elseif #self.Profiles == 2 then
		profile1 = self.Profiles[1]
		profile2 = self.Profiles[2]
	else
		local y = profileselector(#self.Profiles-1, w)
print(y)
		profile1 = self.Profiles[y]
		profile2 = self.Profiles[y+1]
	end
	
	return profile1, profile2
end

function profiler.GetVertex(self, u, w)
	local ht = w*self.Height
	local profile1, profile2 = self:SelectProfiles(u, w)
		
	local profile1vtx = profile1:GetProfileVertex(u)
	local profile2vtx = profile2:GetProfileVertex(u)
	local profvtx = lerp(profile1vtx, profile2vtx, w)
	profvtx[2] = 0

	local vert = {profvtx[1], ht, profvtx[3]}

	local normal = vec3_norm(profvtx )

	return vert, normal
end

local ashape = profiler.new({
	USteps = 90,
	WSteps = 90,
	Thickness = -1,
	--Profiles = {profile1, profile2, profile3},
	Profiles = {profile1, profile2},
	Height = 20,
	})

color("Yellow")
addshape(ashape)

--[[
local verts = ashape:GetVertices()

color("Purple")
for _, v in ipairs(verts) do
	translate(v)
	tetrahedron(0.25)
end
--]]