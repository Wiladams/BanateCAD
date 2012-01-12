--
-- BLight.lua
--
-- Copyright (c) 2011  William Adams
--
--  Dealing with the lighting model

require ("luagl")

local class = require "pl.class"

class.BLight()
function BLight:_init(o)
	-- create object if user does not provide one
	o = o or {
		Ambient = {0.75,0.75,0.75,1},
		Diffuse = {1,1,1,1},
		Position = {0,0,0,0},
		Enabled = true
		}


	self.ID = o.ID or gl.LIGHT0
	self.Enabled = o.Enabled or true

	self.Ambient = o.Ambient
	self.Diffuse = o.Diffuse
	self.Position = o.Position

end

function BLight.Enable(self)
	self.Enabled = true
end

function BLight.Disable(self)
	self.Enabled = false
end

function BLight.RenderAttributes(self)
--print("Ambient: ", self.Ambient);
--print("Diffuse: ", self.Diffuse);
--print("Position: ", self.Position);
--print("ID: ", self.ID);

	if self.Ambient ~= nil then
		gl.Light(self.ID, gl.AMBIENT, self.Ambient);
	end

	if self.Diffuse ~= nil then
		gl.Light(self.ID, gl.DIFFUSE, self.Diffuse);
	end

	if self.Position ~= nil then
		gl.Light(self.ID, gl.POSITION, self.Position);
	end
end

function BLight.Render(self)
	if not self.Enabled then
		gl.Disable(self.ID)
		return
	end

	self:RenderAttributes()

	gl.Enable(self.ID);		-- Make sure light is enabled
end

return BLight
