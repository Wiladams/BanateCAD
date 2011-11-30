--require ("Class")

--[[
	Ambient
	Diffuse
	Specular
	Shininess
	Emission

	Face
--]]
BMaterial = inheritsFrom(nil)

-- Definitions of faces
BMaterial.Front = 1
BMaterial.Back = 2
BMaterial.FrontAndBack = 3

function BMaterial.new(params)
	local new_inst = BMaterial.create()

	new_inst.Ambient = params.Ambient or nil
	new_inst.Diffuse = params.Diffuse or nil
	new_inst.Specular = params.Specular or nil
	new_inst.Shininess = params.Shininess or nil
	new_inst.Emission = params.Emission or nil
	new_inst.Face = params.Face or BMaterial.Front

	return new_inst
end

function BMaterial.SetDefaults()
end

