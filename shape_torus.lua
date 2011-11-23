-- shape_torus.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--

require ("trimesh")
require ("BiParametric")


shape_torus = inheritsFrom(BiParametric)
function shape_torus.new(params)
	local new_inst = shape_torus.create()

	new_inst:Init(params)

	return new_inst
end


-- USteps
-- WSteps
-- Offset
-- Size
function shape_torus.Init(self, params)
	params = params or {}

	self.USteps = params.USteps or 10
	self.WSteps = params.WSteps or 10
	self.Offset = params.Offset or {0,0}
	self.Size = params.Size or {1,1}

	self.ParamFunction = self

	return self
end

function shape_torus.GetValue(self, u, v)
	local theta = u * 2*math.pi;
	local phi = v * 2*math.pi;

	local pt = {
		(self.Offset[2]+self.Size[2]*math.sin(theta))*math.sin(phi),
		(self.Offset[2]+self.Size[2]*math.sin(theta))*math.cos(phi),
		self.Offset[1]+self.Size[1]*math.cos(theta),
		};

	return pt;
end

