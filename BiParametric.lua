require ("Class")
require ("trimesh")
require ("checkerboard")

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
	self.ParamFunction = params.ParamFunction or nil

	return self
end

-- row == 0, WSteps+1
-- column == 0, USteps+1
function BiParametric.GetIndex(self, row, column)
	return row*(self.USteps+1) + column + 1
end

function BiParametric.GetFaces(self)
	local faces = {};

	for w=0, self.WSteps-1 do
		for u=0, self.USteps-1 do
			local v1 = self:GetIndex(w, u)
			local v2 = self:GetIndex(w, u+1)
			local v3 = self:GetIndex(w+1, u+1)
			local v4 = self:GetIndex(w+1, u)

			local tri1 = {v1, v2, v3}
			local tri2 = {v1, v3, v4}

			if self.ColorSampler ~= nil then
				aValue = self.ColorSampler:GetColor(u/self.USteps, w/self.WSteps)
				tri1.Color = aValue
				tri2.Color = aValue
			end

			table.insert(faces, tri1)
			table.insert(faces, tri2)
		end
	end

	return faces;
end

function BiParametric.GetVertex(self, u, w)
	if self.ParamFunction ~= nil then
		return self.ParamFunction:GetVertex(u/self.USteps, w/self.WSteps)
	end

	return nil
end

function BiParametric.GetVertices(self)
	-- If we don't have a function to calculate the values
	-- then just return
	--if self.ParamFunction == nil then return end


	local vertices = {};
	local normals = {};

	for w=0, self.WSteps do
		for u=0, self.USteps do
			local svert, normal = self:GetVertex(u/self.USteps, w/self.WSteps)
			table.insert(vertices, svert);
			table.insert(normals, normal);
		end
	end

	return vertices, normals;
end

function BiParametric.GetMesh(self)
	local mesh = trimesh:new();

	local vertices, normals = self:GetVertices()

	for _,vert in ipairs(vertices) do
		mesh:addvertex(vert)
	end

	local faces = self:GetFaces()
	for _,f in ipairs(faces) do
		mesh:addface(f)
	end

	return mesh
end

function BiParametric.Render(self, renderer)
	if self.ShapeMesh == nil then
		self.ShapeMesh = self:GetMesh()
	end

	renderer:DisplayMesh(self.ShapeMesh);
end
