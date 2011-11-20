-- viewmanager.lua
-- 
-- BanateCAD
-- Copyright (c) 2011  William Adams
--
require ("maths")

--[[
	Global State for host environment management
--]]
angleIncr = 5
diamincr = 0.25


camera = {}

function camera:new(o)
-- create object if user does not provide one
	o = o or {}

	setmetatable(o, self)
	self.__index = self

	o.left=0;
	o.right=0;
	o.bottom=0;
	o.top=0;
	o.zNear = 1;
	o.zFar = 10;

	return o
end


function camera.updateview(self)
--[[

	self.left = -100
	self.right = 100
	self.bottom = -100
	self.top = 100
--]]

	self.left = self.look[1] - self.pos[3]
	self.right = self.look[1] + self.pos[3]
	self.bottom = self.look[2] - self.pos[3]
	self.top = self.look[2] + self.pos[3]
end

function camera.LookAt(self, pos)
	self.look = pos
	self:updateview()
end

function camera.Zoom(self, value)
	self.pos[3] = self.pos[3] + diamincr * value

	self:updateview()

	--zNear = 1
	self.zFar = self.zNear + self.pos[3]*2
end

function camera.Slide(self, value)
	self.pos[1] = self.pos[1] + value * angleIncr
end

function camera.Elevate(self, value)
	self.pos[2] = self.pos[2] + value * angleIncr
end

function camera.GetPosition(self)
	return sph_to_cart(self.pos)
end

defaultcamera = camera:new({pos = sph(0,0,3), look = {0,0,0}})
defaultcamera:updateview()
