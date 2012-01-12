--
-- BLighting.lua
--
-- Copyright (c) 2011  William Adams
--

local class = require "pl.class"

class.BLighting()
function BLighting:_init(o)
	-- create object if user does not provide one
	o = o or {}

	self.Enabled = o.Enabled or true
	self.Lights = o.Lights or {}
	self.GLLights = {}
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
	gl.Enable(gl.LIGHTING)

	for _,light in ipairs(self.Lights) do
		light:Render();
	end


	-- As long as we use the gl.Scale operator anywhere, we must
	-- use gl.NORMALIZE or the normals will be too large
	-- this is a performance hit though.  Ideally, we won't use the
	-- gl.Scale call anywhere, instead changing the geometry directly
	-- Could possibly use gl.RESCALE_NORMAL instead
	gl.Enable(gl.NORMALIZE);
end
