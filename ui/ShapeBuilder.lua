local class = require "pl.class"

class.ShapeBuilder()

function ShapeBuilder:_init()
	self.Vertices = {}
end

function ShapeBuilder.AddVertex(self, vtx)
	table.insert(self.Vertices, Point3D(vtx))
end

function ShapeBuilder.Bezier(self, p1, p2, p3)
	-- If there isn't already a starting point,
	-- then add one
	local p0 = {0,0,0}
	if #self.Vertices < 1 then
		self:AddVertex(p0)
	else
		p0 = self.Vertices[#self.Vertices]
	end


	local pts = {p0, p1, p2, p3}

	local curveSteps = 30;

---[[
	local cv4 = cubic_vec3_to_cubic_vec4(pts);

	for i=0, curveSteps do
		local u = i/curveSteps;
		local cpt = bezier_eval(u, cv4);
		self:AddVertex(cpt)
	end
--]]
end

function ShapeBuilder.LineTo(self, pt1)
	local p0 = {0,0,0}
	if #self.Vertices < 1 then
		self:AddVertex(pt0)
	else
		p0 = self.Vertices[#self.Vertices]
	end

	self:AddVertex(pt1)
end
