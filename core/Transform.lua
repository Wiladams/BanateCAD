local class = require "pl.class"

class.Transform()

function Transform:_init(params)
	params = params or {
		Translation = {0,0,0};
		Rotation = 0;
		Scale = {1,1,1}
	}

	self.Translation = {unpack(params.Translation)}
	self.Rotation = params.Rotation
	self.Scale = {unpack(params.Scale)}
end

function Transform.Get2DMatrix(self)
	-- Create an appropriate transform matrix
	local cosangle = math.cos(self.Rotation)
	local sinangle = math.sin(self.Rotation)
	local sx = self.Scale[1];
	local sy = self.Scale[2];
	local dx = self.Translation[1];
	local dy = self.Translation[2];

	local mat = {sx*cosangle, sinangle, -sinangle, sy*cosangle, dx, dy}

	return mat;
end
