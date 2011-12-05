--require ("Class")
--require ("maths")
require ("openscad_print")

DisplacementSampler = inheritsFrom(nil)
function DisplacementSampler.new(params)
	local new_inst = DisplacementSampler.create()

	new_inst.VertexSampler = params.VertexSampler
	new_inst.HeightSampler = params.HeightSampler
	new_inst.MaxHeight = params.MaxHeight or 1

	return new_inst
end


function DisplacementSampler.GetVertex(self, u, w)
	-- Get vertext from vertex sampler
	vert, norm = self.VertexSampler:GetVertex(u,w)

	-- Get the thickness from the HeightSampler
	local height = self.HeightSampler:GetHeight(u,w) * self.MaxHeight

	-- Add the height from the height sampler
	local nvert = vec3_add(vec3_mults(norm,height), vert)

--vec3_print_tuple(vert)
--vec3_print_tuple(nvert)


	return nvert, norm

end

