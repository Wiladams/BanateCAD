
local class = require "pl.class"


--[[
	Ambient
	Diffuse
	Specular
	Shininess
	Emission

	Face
--]]

class.BMaterial()

-- Definitions of faces
BMaterial.Front = 1
BMaterial.Back = 2
BMaterial.FrontAndBack = 3

function BMaterial:_init(params)

	self.Ambient = params.Ambient or nil
	self.Diffuse = params.Diffuse or nil
	self.Specular = params.Specular or nil
	self.Shininess = params.Shininess or nil
	self.Emission = params.Emission or nil
	self.Face = params.Face or BMaterial.Front

end

function BMaterial.SetDefaults()
end

