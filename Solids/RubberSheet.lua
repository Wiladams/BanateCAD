-- RubberSheet.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
--require ("trimesh")
--require ("Shape")
require ("BiParametric")
local class = require "pl.class"


-- USteps
-- WSteps
-- Size
-- Resolution
-- VertexSampler - GetVertex

class.RubberSheet(BiParametric)
function RubberSheet:_init(params)
	params = params or {}

	self:super(params)

	self.Thickness = params.Thickness

	-- Get our specifics out of the parameters
	self.Size = params.Size or {1,1}
	self.Resolution = params.Resolution or {1,1}
	self.USteps = self.Size[1] * self.Resolution[1]
	self.WSteps = self.Size[2] * self.Resolution[2]

	self.VertexSampler = params.VertexSampler or nil
	self.ColorSampler = params.ColorSampler or nil
end

function RubberSheet.GetVertex(self, u, w)
	if self.VertexSampler ~= nil then
		return self.VertexSampler:GetVertex(u,w)
	end

	local x = u*self.Size[1]
	local y = w*self.Size[2]
	local z = 0

	return {x,y,z}
end
