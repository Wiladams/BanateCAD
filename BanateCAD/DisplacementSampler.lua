local class = require "pl.class"
--require ("maths")


class.DisplacementSampler()

function DisplacementSampler:_init(params)

	self.VertexSampler = params.VertexSampler
	self.HeightSampler = params.HeightSampler
	self.MaxHeight = params.MaxHeight or 1

end


function DisplacementSampler.GetVertex(self, u, w)
	-- Get vertext from vertex sampler
	vert, norm = self.VertexSampler:GetVertex(u,w)

	-- Get the thickness from the HeightSampler
	local height = self.HeightSampler:GetHeight(u,w) * self.MaxHeight

	-- Add the height from the height sampler
	local nvert = vec3_add(vec3_mults(norm,height), vert)

	return nvert, norm

end

