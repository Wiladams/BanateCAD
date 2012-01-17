local class = require "pl.class"

class.Rectangle()

function Rectangle:_init(...)
	local x1 = 0
	local y1 = 0
	local x2 = 0
	local y2 = 0

	if arg.n == 2 then
		x1 = arg[1][1]
		y1 = arg[1][2]
		x2 = x1 + arg[2][1]
		y2 = y1 + arg[2][2]
	elseif arg.n == 4 then
		x1 = arg[1]
		y1 = arg[2]
		x2 = arg[3]
		y2 = arg[4]
	end

	self:SetRect(x1, y1, x2, y2);
end


function Rectangle.IsEmpty(self)
	return (self.Left == self.Right) and (self.Top == self.Bottom);
end


function Rectangle.SetRect(self, x1, y1, x2, y2)
	self.Left = x1
	self.Right = x2
	self.Top = y1
	self.Bottom = y2

	self:Normalize();

	self.Width = self.Right - self.Left;
	self.Height = self.Bottom - self.Top;
end

function Rectangle.Normalize(self)
	local t=0;

	if (self.Left > self.Right) then
		t = self.Left;
		self.Left = self.Right;
		self.Right = t;
	end

	if (self.Top > self.Bottom) then
		t = self.Top;
		self.Top = self.Bottom;
		self.Bottom = t;
	end

	return self;
end

function Rectangle.Clip(self, r)
	if (self.Right > r.Right) then
		self.Right = r.Right;
	end

	if (self.Bottom > r.Bottom) then
		self.Bottom = r.Bottom;
	end

	if (self.Left < r.Left) then
		self.Left = r.Left;
	end

	if (self.Top < r.Top) then
		self.Top = r.Top;
	end

	return self:IsValid();
end

function Rectangle.IsValid(self)
	return self.Left <= self.Right and self.Top <= self.Bottom;
end

function Rectangle.Contains(self, x, y)
	return ((x >= self.Left) and (x <= self.Right) and (y >= self.Bottom) and (y <= self.Top));
end

-- Change the shape of this rectangle by intersecting
-- it with another one.
function Rectangle.Intersect(self, rect)
	local result = Rectangle.Intersect(rect, this);

	self.Left = result.Left;
	self.Top = result.Bottom;
	self.Right = result.Right;
	self.Bottom = result.Bottom;
end


function Rectangle.Inflate(self, ...)
	local dx = 0
	local dy = 0

	if arg.n == 2 then
		dx = arg[1]
		dy = arg[2]
	elseif arg.n == 1 then
		dx = arg[1]
		dy = arg[1]
	end

	self:SetRect(self.Left - dx, self.Top - dy, self.Right + dx, self.Bottom + dy)
end

function Rectangle.Offset(self, x, y)
	self:SetRect(self.Left + x, self.Top + y, self.Right + x, self.Bottom + y)
end

--[[
	STATIC Methods
--]]
-- Generic routine to create the intersection between
-- two rectangles.
--
function Rectangle.Intersect(left, right)
	local x1 = math.max(left.Left, right.Left);
	local x2 = math.min(left.Right, right.Right);
	local y1 = math.max(left.Top, right.Top);
	local y2 = math.min(left.Bottom, right.Bottom);

	if (x2 >= x1 and y2 >= y1) then
		return Rectangle(x1, y1, x2, y2);
	end

	return EmptyRect;
end

function Rectangle.Union(left, right)
	local x1 = math.min(left.Left, right.Left);
	local x2 = math.max(left.Right, right.Right);
	local y1 = math.min(left.Bottom, right.Bottom);
	local y2 = math.max(left.Top, right.Top);

	return Rectangle(x1, y1, x2, y2);
end

function Rectangle.__tostring(self)
	return '{'..self.Left..','..self.Top..','..self.Right..','..self.Bottom..'}';
end

Rectangle.Empty = Rectangle();


--[[
rec1 = Rectangle({10, 10}, {100, 100})
rec2 = Rectangle({20, 20}, {100, 100})
rec3 = rec1:Intersect(rec2)

print(rec1)
print(rec2)
print(rec3)

print(rec1.Left, rec1.Top, rec1.Width, rec1.Height)
--]]
