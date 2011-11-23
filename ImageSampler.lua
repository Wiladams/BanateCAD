require("gd")
require ("openscad_print")
require ("Class")

ImageSampler = inheritsFrom(nil);

function ImageSampler.new(params)
	local new_inst = ImageSampler.create()

	new_inst:Init(params)

	return new_inst
end

function ImageSampler.Init(self, params)
	params = params or {}

	self.Filename = params.Filename or nil

	-- Need to load the image data
	-- Assume a .png file for now
	local img = gd.createFromPng(self.Filename)

	if img == nil then return nil end

	self.Image = img
	self.Width, self.Height = self.Image:sizeXY()

	return self
end

function ImageSampler.GetColor(self, u, w)
	local width,height = self.Image:sizeXY()
	-- calculate pixel coordinates
	local x = u*width-1
	local y = height-1-(w*height-1)

	local pixel = self.Image:getPixel(x,y)
	local r = self.Image:red(pixel)
	local g = self.Image:green(pixel)
	local b = self.Image:blue(pixel)

	return {r/255,g/255,b/255,1}
end

--[[
--local is = ImageSampler:new({Filename='profile_80_60.png'})
local is = ImageSampler:new({Filename='profile_1024_768.png'})

c = is:GetColor(0.5,0.5)
vec3_print_tuple(c)
--]]
