--require ("Class")
--require ("trimesh")
require ("checkerboard")
require ("openscad_print")

BiParametric = inheritsFrom(Shape)

-- Every BiParametric needs:
--	USteps
--	WSteps
--	ColorSampler
--	ParamFunction
function BiParametric.new(params)
	params = params or {}		-- create object if user does not provide one

	local new_inst = BiParametric.create()
	new_inst:Init(params)

	return new_inst
end

function BiParametric.Init(self, params)
	self.USteps = params.USteps or 10
	self.WSteps = params.WSteps or 10
	self.ColorSampler = params.ColorSampler or nil
	self.VertexFunction = params.VertexFunction or nil
	self.Thickness = params.Thickness or nil

	return self
end

-- row == 0, WSteps+1
-- column == 0, USteps+1
function BiParametric.GetIndex(self, row, column, offset)
	return offset + (row*(self.USteps+1) + column + 1)
end

function BiParametric.GetFaces(self)
	local faces = {};

	for w=0, self.WSteps-1 do
		for u=0, self.USteps-1 do
			local v1 = self:GetIndex(w, u, 0)
			local v2 = self:GetIndex(w, u+1, 0)
			local v3 = self:GetIndex(w+1, u+1, 0)
			local v4 = self:GetIndex(w+1, u, 0)

			local tri1 = {v1, v2, v3}
			local tri2 = {v1, v3, v4}

			if self.ColorSampler ~= nil then
				local aValue = self.ColorSampler:GetColor(u/self.USteps, w/self.WSteps)
				tri1.Color = aValue
				tri2.Color = aValue
			end

			-- TODO
			-- this would be a good place to check and see
			-- if a triangle is essentially non-existant, and
			-- eliminate it from the list of faces
			-- This happens at the poles of an ellipsoid for example
			table.insert(faces, tri1)
			table.insert(faces, tri2)
		end
	end

	if self.Thickness == nil then
		return faces
	end

	local offset = ((self.WSteps+1)*(self.USteps+1))	-- skip past 'outside' surface

	-- Get the faces for the 'inside' if we have a thickness
	-- We should do a sanity check to ensure we have enough vertices
	-- to describe the inside faces
	for w=0, self.WSteps-1 do
		for u=0, self.USteps-1 do
			local iv1 = self:GetIndex(w, u, offset)
			local iv2 = self:GetIndex(w, u+1, offset)
			local iv3 = self:GetIndex(w+1, u+1, offset)
			local iv4 = self:GetIndex(w+1, u, offset)

			local tri3 = {iv1, iv3, iv2}
			local tri4 = {iv1, iv4, iv3}

			--local tri3 = {f2v1, f2v2, f2v3}
			--local tri4 = {f2v1, f2v3, f2v4}

--[[
-- Need a color sampler for the 'inside'
				if self.ColorSampler ~= nil then
					aValue = self.ColorSampler:GetColor(u/self.USteps, w/self.WSteps)
					tri1.Color = aValue
					tri2.Color = aValue
				end
--]]
			-- TODO
			-- this would be a good place to check and see
			-- if a triangle is essentially non-existant, and
			-- eliminate it from the list of faces
			-- This happens at the poles of an ellipsoid for example
				table.insert(faces, tri3)
				table.insert(faces, tri4)
		end
	end


	-- Create the edging faces

	-- Front Edge, u = 0,self.USteps-1, w=0
	for col = 0, (self.USteps-1) do
		local ffv1 = self:GetIndex(0,col, offset)
		local ffv2 = self:GetIndex(0,col+1, offset)
		local ffv3 = self:GetIndex(0,col+1, 0)
		local ffv4 = self:GetIndex(0,col, 0)

		local tri5 = {ffv1, ffv2, ffv3}
		local tri6 = {ffv1, ffv3, ffv4}


		table.insert(faces, tri5)
		table.insert(faces, tri6)
	end

	-- Back Edge, u = 0,self.USteps-1, w=self.WSteps
	for col = 0, (self.USteps-1) do
		local bfv1 = self:GetIndex(self.WSteps, col, offset)
		local bfv2 = self:GetIndex(self.WSteps, col+1, offset)
		local bfv3 = self:GetIndex(self.WSteps, col+1, 0)
		local bfv4 = self:GetIndex(self.WSteps, col, 0)

		local tri9 = {bfv1, bfv3, bfv2}
		local tri10 = {bfv1, bfv4, bfv3}


		table.insert(faces, tri9)
		table.insert(faces, tri10)
	end

	-- Right Edge, u = self.USteps, w=0, self.WSteps-1

	for row=0, (self.WSteps-1) do
		local rfv1 = self:GetIndex(row, self.USteps, offset)
		local rfv2 = self:GetIndex(row+1, self.USteps, offset)
		local rfv3 = self:GetIndex(row+1, self.USteps, 0)
		local rfv4 = self:GetIndex(row, self.USteps, 0)

		local tri7 = {rfv1, rfv2, rfv3}
		local tri8 = {rfv1, rfv3, rfv4}

		table.insert(faces, tri7)
		table.insert(faces, tri8)
	end

	-- Left Edge, u = 0, w=0, self.WSteps-1

	for row=0, (self.WSteps-1) do
		local lfv1 = self:GetIndex(row, 0, offset)
		local lfv2 = self:GetIndex(row+1, 0, offset)
		local lfv3 = self:GetIndex(row+1, 0, 0)
		local lfv4 = self:GetIndex(row, 0, 0)

		local tri11 = {lfv1, lfv2, lfv3}
		local tri12 = {lfv1, lfv3, lfv4}

		table.insert(faces, tri11)
		table.insert(faces, tri12)
	end

	return faces;
end

function BiParametric.GetVertex(self, u, w)
	if self.VertexFunction ~= nil then
		return self.VertexFunction:GetVertex(u, w)
	end

	return nil
end

function BiParametric.GetVertices(self)
	local vertices = {};
	local normals = {};

	for w=0, self.WSteps do
		for u=0, self.USteps do
			local svert, normal = self:GetVertex(u/self.USteps, w/self.WSteps)
			table.insert(vertices, vec.new(svert));
			if normal ~= nil then
				table.insert(normals, normal);
			end
		end
	end

	if self.Thickness == nil then
		return vertices
	end

--print("Extra Vertices")

	-- If we have a thickness, then use the normals to calculate
	-- the set of vertices for the 'inside'
	local nverts = #vertices
	if #normals > 0  then
		for i=1,nverts do
			local norm = normals[i]
			local vert = vertices[i]
			local nvert = vec3_add(vec3_mults(norm, self.Thickness), vert)

			table.insert(vertices, nvert)
		end
	end

	return vertices, normals;
end

function BiParametric.GetMesh(self)
	local amesh = trimesh:new();

	self.Vertices, self.Normals = self:GetVertices()

	for _,vert in ipairs(self.Vertices) do
		amesh:addvertex(vert)
	end

	self.Faces = self:GetFaces()
	for _,f in ipairs(self.Faces) do
		amesh:addface(f)
	end

	return amesh
end

function BiParametric.RenderSelf(self, renderer)
	if self.ShapeMesh == nil then
		self.ShapeMesh = self:GetMesh()
	end

	renderer:DisplayMesh(self.ShapeMesh);
end
