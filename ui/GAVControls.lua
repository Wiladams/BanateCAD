-- AVControls.lua

require "GShape"


--[============================[
		PLAY
--]============================]
class.GAVPlay(GShape)

function GAVPlay:_init(params)
	params = params or {}

	self:super(params)

	local w = self.Frame.Width;
	local h = self.Frame.Height;
	local left, top = self.Frame:GetCenter();

	local sb1 = ShapeBuilder()
	sb1:AddVertex(vec3(left + w * -0.25, top+ h * 0.25,0))
	sb1:LineTo(vec3(left + w * -0.25, top + h * -0.25,0))
	sb1:LineTo(vec3(left + w * 0.25, top + h * 0, 0))

	self.shape1 = sb1;

end

function GAVPlay:RenderSelf(graphPort)
	graphPort:SetFillColor(self.FillColor)
	graphPort:SetStrokeColor(self.StrokeColor)
	self.shape1:Render(graphPort)
end


--[============================[
		PAUSE
--]============================]
class.GAVPause(GShape)

function GAVPause:_init(params)
	params = params or {}
	self:super(params)

	local w = self.Frame.Width;
	local h = self.Frame.Height;
	local left, top = self.Frame:GetCenter();

	local sb1 = ShapeBuilder()
	sb1:AddVertex(vec3(left + w * 0.125, top+ h * 0.25,0))
	sb1:LineTo(vec3(left + w * 0.125, top + h * -0.25,0))
	sb1:LineTo(vec3(left + w * 0.375, top + h * -.25, 0))
	sb1:LineTo(vec3(left + w * 0.375, top + h * 0.25, 0))

	self.shape1 = sb1;

	local sb2 = ShapeBuilder()
	sb2:AddVertex(vec3(left + w * -0.125, top+ h * 0.25,0))
	sb2:LineTo(vec3(left + w * -0.125, top + h * -0.25,0))
	sb2:LineTo(vec3(left + w * -0.375, top + h * -.25, 0))
	sb2:LineTo(vec3(left + w * -0.375, top + h * 0.25, 0))
	self.shape2 = sb2;

end

function GAVPause:RenderSelf(graphPort)
	graphPort:SetFillColor(self.FillColor)
	graphPort:SetStrokeColor(self.StrokeColor)
	self.shape1:Render(graphPort)
	self.shape2:Render(graphPort)
end

--[============================[
		SKIP
--]============================]
class.GAVSkip(GShape)

function GAVSkip:_init(params)
	params = params or {}
	self:super(params)

	local w = self.Frame.Width;
	local h = self.Frame.Height;
	local left, top = self.Frame:GetCenter();

	local sb1 = ShapeBuilder()
	sb1:AddVertex(vec3(left + w * -0.375, top+ h * 0.25,0))
	sb1:LineTo(vec3(left + w * -0.375, top + h * -0.25,0))
	sb1:LineTo(vec3(left + w * 0, top + h * 0, 0))

	self.shape1 = sb1;

	local sb2 = ShapeBuilder()
	sb2:AddVertex(vec3(left + w * 0.125, top+ h * 0.25,0))
	sb2:LineTo(vec3(left + w * 0.125, top + h * -0.25,0))
	sb2:LineTo(vec3(left + w * 0.375, top + h * -.25, 0))
	sb2:LineTo(vec3(left + w * 0.375, top + h * 0.25, 0))
	self.shape2 = sb2;

end

function GAVSkip:RenderSelf(graphPort)
	graphPort:SetFillColor(self.FillColor)
	graphPort:SetStrokeColor(self.StrokeColor)

	self.shape1:Render(graphPort)
	self.shape2:Render(graphPort)
end


--[============================[
		STOP
--]============================]
class.GAVStop(GShape)

function GAVStop:_init(params)
	params = params or {}
	self:super(params)

	local w = self.Frame.Width;
	local h = self.Frame.Height;
	local left, top = self.Frame:GetCenter();

	local sb1 = ShapeBuilder()
	sb1:AddVertex(vec3(left + w * -0.25, top+ h * 0.25,0))
	sb1:LineTo(vec3(left + w * -0.25, top + h * -0.25,0))
	sb1:LineTo(vec3(left + w * 0.25, top + h * -.25, 0))
	sb1:LineTo(vec3(left + w * 0.25, top + h * 0.25, 0))

	self.shape1 = sb1;

end

function GAVStop:RenderSelf(graphPort)
	graphPort:SetFillColor(self.FillColor)
	graphPort:SetStrokeColor(self.StrokeColor)
	self.shape1:Render(graphPort)
end

