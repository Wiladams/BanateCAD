--
-- BLight.lua
--
-- Copyright (c) 2011  William Adams
--
--  Dealing with the lighting model

require ("luagl")
require ("openscad_print")

BLight = {}
function BLight:new(o)
	-- create object if user does not provide one
	o = o or {
		Ambient = {0.75,0.75,0.75,1},
		Diffuse = {1,1,1,1},
		Position = {0,0,0,0},
		Enabled = true
		}

	setmetatable(o, self)
	self.__index = self

	o.ID = o.ID or gl.LIGHT0
	o.Enabled = o.Enabled or true

	return o
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
