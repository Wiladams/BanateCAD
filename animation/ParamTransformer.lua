
ParamTransformer = inheritsFrom(nil)
function ParamTransformer.new(params)
	local new_inst = ParamTransformer.create()

	new_inst.TranslateFunctor = params.TranslateFunctor
	new_inst.ScaleFunctor = params.ScaleFunctor
	new_inst.RotateFunctor = params.RotateFunctor

	return new_inst
end


function ParamTransformer.GetTransform(self, u)
	local transform = {}

	if self.TranslateFunctor ~= nil then
		transform.Translation = functorcall(self.TranslateFunctor,u)
	else
		transform.Translation = {0,0,0}
	end

	if self.ScaleFunctor ~= nil then
		transform.Scale = functorcall(self.ScaleFunctor,u)
	else
		transform.Scale = {1,1,1}
	end


	if self.RotateFunctor ~= nil then
		transform.Rotation = self.RotateFunctor:GetValue(u)
	end

	return transform
end

