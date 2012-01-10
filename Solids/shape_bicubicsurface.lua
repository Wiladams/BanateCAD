-- shape_bicubicsurface.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
--require ("Class")
--require ("trimesh")
--require ("BiParametric")
--require ("ImageSampler")

-- Create a subclass of BiParametric
local class = require "pl.class"
class.shape_bicubicsurface(BiParametric)


function shape_bicubicsurface:_init(params)
	params = params or {}

	self:super(params)

	-- Now set what we want explicitly
	self.M = params.M or cubic_bezier_M()
	self.UMult = params.UMult or 1
	self.Mesh = params.Mesh or {
		{{0,0,0,1},{0.33, 0,0,1},{0.66,0,0,1},{1,0,0,1}},
		{{0,0.33,0,1},{0.33, 0.33,0,1},{0.66,0.33,0,1},{1,0.33,0,1}},
		{{0,0.66,0,1},{0.33, 0.66,0,1},{0.66,0.66,0,1},{1,0.66,0,1}},
		{{0,1,0,1},{0.33, 1,0,1},{0.66,1,0,1},{1,1,0,1}},
		}

end


function shape_bicubicsurface.GetVertex(self, u,w)
	local svert, normal = bicerp(u, w, self.Mesh, self.M, self.UMult);
	return svert, normal;
end


