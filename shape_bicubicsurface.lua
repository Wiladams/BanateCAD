-- shape_bicubicsurface.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
--require ("trimesh")
require ("BiParametric")
require ("Class")
--require ("maths")
require ("ImageSampler")

-- Create a subclass of BiParametric
shape_bicubicsurface = inheritsFrom(BiParametric)


function shape_bicubicsurface.new(params)
	local new_inst = shape_bicubicsurface.create()

	new_inst:Init(params)

	return new_inst
end

-- USteps
-- WSteps
-- Mesh
-- M
-- UMult
function shape_bicubicsurface.Init(self, params)
	params = params or {}

	-- Allow the base class to pull out what it wants
	self:superClass():Init(params)

	self.USteps = params.USteps or 10
	self.WSteps = params.WSteps or 10
	self.ColorSampler = params.ColorSampler or nil
	--self.ParamFunction = params.ParamFunction or nil

	-- Now set what we want explicitly
	self.Thickness = params.Thickness or -1
	self.M = params.M or cubic_bezier_M()
	self.UMult = params.UMult or 1
	self.Mesh = params.Mesh or {
		{{0,0,0,1},{0.33, 0,0,1},{0.66,0,0,1},{1,0,0,1}},
		{{0,0.33,0,1},{0.33, 0.33,0,1},{0.66,0.33,0,1},{1,0.33,0,1}},
		{{0,0.66,0,1},{0.33, 0.66,0,1},{0.66,0.66,0,1},{1,0.66,0,1}},
		{{0,1,0,1},{0.33, 1,0,1},{0.66,1,0,1},{1,1,0,1}},
		}

	return self
end

function shape_bicubicsurface.GetVertex(self, u,w)
	local svert, normal = bicerp(u, w, self.Mesh, self.M, self.UMult);
	return svert, normal;
end


--[[
local colorSampler = ImageSampler.new({Filename='profile_1024_768.png'})


local lshape = shape_bicubicsurface.new({
		M=cubic_bezier_M(),
		UMult=1,
		Mesh = mesh,
		Thickness = thickness,
		USteps = usteps,
		WSteps = wsteps,
		ColorSampler = colorSampler,
		})
--]]
