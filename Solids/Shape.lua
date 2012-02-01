
local class = require "pl.class"

-- Create a base class, Shape
class.Shape()

function Shape:_init(params)
	params = params or {}

	self.Material = params.Material
	self.Transform = params.Transform
end

-- The primary function of a shape
function Shape.RenderBegin(self, graphPort)
	if self.Transform ~= nil then
		graphPort:SaveTransform()

		if self.Transform.Translation ~= nil then
			graphPort:Translate(self.Transform.Translation)
		end

		if self.Transform.Scale ~= nil then
			graphPort:Scale(self.Transform.Scale)
		end
	end

	if self.Material ~= nil then
		graphPort:ApplyMaterial(self.Material)
	end
end

function Shape.RenderSelf(self, graphPort)
end

function Shape.Render(self, graphPort)
	-- From Actor
	--self:RenderBackground(graphPort)
	--self:RenderMembers(graphPort)
	--self:RenderForeground(graphPort)

	self:RenderBegin(renderer)
	self:RenderSelf(renderer)
	self:RenderEnd(renderer)
end

function Shape.RenderEnd(self, renderer)
	if self.Transform ~= nil then
		renderer:RestoreTransform()
	end
end

function Shape.SetTransform(self, atrans)
	self.Transform = atrans
end

function Shape.Update(self, toTime)
	--print("Shape.Update: ", toTime)
end

function Shape.__tostring(self)
	return "Shape"
end


--====================================
--	USEFUL FUNCTIONS
--====================================
function sortvertices(v1, v2)
	local xmin = math.min(v1[1], v2[1])
	local xmax = math.max(v1[1], v2[1])

	local ymin = math.min(v1[2], v2[2])
	local ymax = math.max(v1[2], v2[2])

	local zmin = math.min(v1[3], v2[3])
	local zmax = math.max(v1[3], v2[3])

	return vec3(xmin,ymin,zmin), vec3(xmax, ymax, zmax)
end


return Shape
