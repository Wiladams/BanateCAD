--
-- BLighting.lua
--
-- Copyright (c) 2011  William Adams
--

BLighting = {}
function BLighting:new(o)
	-- create object if user does not provide one
	o = o or {
		Enabled = true,
		Lights = {}
		}

	setmetatable(o, self)
	self.__index = self

	o.Enabled = o.Enabled or true
	o.Lights = o.Lights or {}
	o.GLLights = {}

	return o
end

function BLighting.Enable(self)
	self.Enabled = true
end

function BLighting.Disable(self)
	self.Enabled = false
end

function BLighting.AddLight(self, aLight)
	table.insert(self.Lights, aLight);
end

function BLighting.Render(self)
	for _,light in ipairs(self.Lights) do
		light:Render();
	end

	gl.Enable(gl.LIGHTING)
	-- As long as we use the gl.Scale operator anywhere, we must
	-- use gl.NORMALIZE or the normals will be too large
	-- this is a performance hit though.  Ideally, we won't use the
	-- gl.Scale call anywhere, instead changing the geometry directly
	-- Could possibly use gl.RESCALE_NORMAL instead
	gl.Enable(gl.NORMALIZE);
end
