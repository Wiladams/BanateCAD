local class = require "pl.class"

class.CDTransform()

function CDTransform:_init(params)
	params = params or {
		Translation = {0,0,0};
		Rotation = 0;
		Scale = {1,1,1}
	}

	self.Translation = {unpack(params.Translation)}
	self.Rotation = params.Rotation
	self.Scale = {unpack(params.Scale)}
end



--[[
--]]

class.CDTransformer()

function CDTransformer:_init(canvas)
	self.canvas = canvas;
	self.TransformStack = {};
	self:MakeIdentity();
end

function CDTransformer.MakeIdentity(self)
	self.CurrentTransform = CDTransform();

	self:ApplyTransform()
end

function CDTransformer.Clear(self)
	self.TransformStack = {}
	self:MakeIdentity()
end

function CDTransformer.Get2DMatrix(self)
	-- Create an appropriate transform matrix
	local cosangle = math.cos(self.CurrentTransform.Rotation)
	local sinangle = math.sin(self.CurrentTransform.Rotation)
	local sx = self.CurrentTransform.Scale[1];
	local sy = self.CurrentTransform.Scale[2];
	local dx = self.CurrentTransform.Translation[1];
	local dy = self.CurrentTransform.Translation[2];

	local mat = {sx*cosangle, sinangle, -sinangle, sy*cosangle, dx, dy}

	return mat;
end

function CDTransformer.ApplyTransform(self)
	local mat = self:Get2DMatrix()

	if self.canvas then
		--self.canvas:Transform(nil)
		self.canvas:Transform(mat)
	end
end

function CDTransformer.Translate(self, tx, ty, tz)
	self.CurrentTransform.Translation[1] = self.CurrentTransform.Translation[1] + tx
	self.CurrentTransform.Translation[2] = self.CurrentTransform.Translation[2] + ty
	self.CurrentTransform.Translation[3] = self.CurrentTransform.Translation[3] + tz

	self:ApplyTransform()
end

function CDTransformer.Scale(self, sx, sy, sz)
	self.CurrentTransform.Scale[1] = self.CurrentTransform.Scale[1] * sx
	self.CurrentTransform.Scale[2] = self.CurrentTransform.Scale[2] * sy
	self.CurrentTransform.Scale[3] = self.CurrentTransform.Scale[3] * sz

	self:ApplyTransform()
end

function CDTransformer.Rotate(self, rads)
	self.CurrentTransform.Rotation = self.CurrentTransform.Rotation + rads

	self:ApplyTransform()
end

function CDTransformer.PushMatrix(self)
	local tfm = CDTransform(self.CurrentTransform)

	table.insert(self.TransformStack, tfm)
end

function CDTransformer.PopMatrix(self)
	if #self.TransformStack < 1 then
		return self.CurrentTransform
	end

	self.CurrentTransform = table.remove(self.TransformStack)
	self:ApplyTransform()

	return self.CurrentTransform
end

function arrtostr(arr)
	local str = string.format("{%f, %f, %f}", arr[1], arr[2], arr[3]);
	return str
end

function CDTransformer.PrintTransform(self, tfm)
	print("Translation: ", arrtostr(tfm.Translation));
	print("Rotation: ", tfm.Rotation);
	print("Scale: \t", arrtostr(tfm.Scale));
end

function CDTransformer.Print2DMatrix(self)
	print("===== 2D MATRIX =====")
	local mat = self:Get2DMatrix()
	print(mat[1], mat[2], mat[3], mat[4], mat[5], mat[6]);
end

function CDTransformer.PrintAll(self)
	print("Current Transform: ")
	self:PrintTransform(self.CurrentTransform)
	self:Print2DMatrix()

	-- for each transform in the stack, print them
	print("===== STACK ENTRIES =====", #self.TransformStack)
	for _,tfm in ipairs(self.TransformStack) do
		self:PrintTransform(tfm)
	end
end

--[[
	print("CDTransformer.lua - TEST");

	local tfm1 = CDTransformer()
	tfm1:PushMatrix()


	--print("Scale")
	tfm1:Scale(1, -1, 1)

	--tfm1:PrintAll();

	--tfm1:PushMatrix()
	--print("Translation")
	tfm1:Translate(10, 10, -5)


	--tfm1:PrintAll();

	--tfm1:PopMatrix();

print("===== After PUSH Matrix =====");
	tfm1:PrintAll();

print("===== After POP Matrix =====");
	tfm1:PopMatrix();
	tfm1:PrintAll();

--]]
