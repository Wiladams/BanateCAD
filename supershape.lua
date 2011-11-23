--
-- supershape.lua
-- Implementation of the SuperFormula for generating objects
-- Copyright (c) 2011  William Adams
--

require ("CADVM")
require ("trimesh")
require ("checkerboard")

-- Helpful math routines
-- Calculate length of a vector
function vlength(v)
	return math.sqrt(v[1]*v[1]+v[2]*v[2]+v[3]*v[3])
end

-- Turn polar back to cartesian
function pocart(r0,r1, t1, p1)
	return {r0*math.cos(t1)*r1*math.cos(p1),r0*math.sin(t1)*r1*math.cos(p1),r1*math.sin(p1)}
end

function nozeros(v1,v2,v3,v4)
	return v1 ~=0 and v2~=0 and v3~=0 and v3~=0
end

--[[
=========================================
 SuperFormula evaluation
=========================================
--]]
-- Create an instance of the supershape data structure
--[[
function supershape(m,n1,n2, n3, a, b)
	return {m,n1,n2,n3,a,b}
end
--]]

superformula = {}

function superformula:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end


function superformula.SSCos(self, phi)
	return math.pow( math.abs(math.cos(self.m*phi/4) / self.a), self.n2)
end

function superformula.SSSin(self, phi)
	return math.pow(math.abs(math.sin(self.m*phi/4) / self.b), self.n3)
end

function superformula.SSR(self, phi)
	return math.pow((self:SSCos(phi) + self:SSSin(phi)), 1/self.n1)
end


--[[

	Module: RenderSuperShape()

	Description: Render a SuperFormula based shape in 3D

	Note:
	In order to truly appreciate what's going on here, and what are useful parameters to play
	with, you should consult the original Paul Bourke web page:
		http://paulbourke.net/geometry/supershape3d/
--]]

--texture = checkerboard:new({columns=32, rows=32})

shape_supershape={}
function shape_supershape:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end

function shape_supershape.meshindex(self, col, row, width)
	local index = ((row-1)*width)+col;
	return index;
end

function shape_supershape.triangle_faces_for_grid(self, width, height)
	local indices = {};
	local lastcol = width-1
	local lastrow = height-1

	for row =1, lastrow do
		local quadstrip = {};

		for col =1, lastcol do
			local tri1 = {self:meshindex(col, row, width), self:meshindex(col+1, row, width), self:meshindex(col+1,row+1, width)}
			local tri2 = {self:meshindex(col, row, width), self:meshindex(col+1, row+1, width), self:meshindex(col, row+1, width)}

			table.insert(indices, tri1)
			table.insert(indices, tri2)
		end

		-- connect back to beginning for a given row
		local lasttri1 = {self:meshindex(width, row, width), self:meshindex(1, row, width), self:meshindex(1,row+1, width)}
		local lasttri2 = {self:meshindex(width, row, width), self:meshindex(1, row+1, width), self:meshindex(width, row+1, width)}
		table.insert(indices, lasttri1);
		table.insert(indices, lasttri2);
	end

	return indices;
end

function shape_supershape.GetMesh(self)
-- theta (longitude) -pi to pi
	local thetalow = -math.pi
	local thetahigh = math.pi
	local thetarange = thetahigh - thetalow;

-- phi (latitude) -pi/2 to pi/2
	local philow = -math.pi/2
	local phihigh = math.pi/2
	local phirange = phihigh-philow

-- Create the mesh we're going to stuff with
-- vertices and faces
	local mesh = trimesh:new({name=self.name})

	-- First calculate all the vertices
	for j = 0, self.phisteps do
		phifrac = j/self.phisteps
		local phi = philow + phifrac * phirange

		for i = 0, self.thetasteps-1 do
			thetafrac = i/self.thetasteps
			local theta = thetalow +   thetafrac * thetarange

			-- Calculate 2 radii
			local r0 = self.shape1:SSR(theta)
			local r1 = self.shape2:SSR(phi)

			if nozeros(r0,r1) then
				vert = pocart(1/r0,1/r1,theta,phi)
				vert.texcoord = {thetafrac, phifrac}
				--vert.color = texture:GetColor(phifrac, thetafrac)

				local pa = mesh:addvertex(vert)
			end
		end
	end

	-- Now that we have all the vertices
	-- Add all the faces
	local indices = self:triangle_faces_for_grid(self.thetasteps, self.phisteps+1);

	for i,v in ipairs(indices) do
		mesh:addface(v)
	end

	return mesh
end
