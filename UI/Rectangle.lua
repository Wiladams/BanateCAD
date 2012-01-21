local class = require "pl.class"

class.Rectangle()

function Rectangle:_init(...)
--print("Rectangle:_init: ", arg.n)

	local dimension = {0,0}
	local origin = {0,0}

	if arg.n == 1 then
		-- Copy constructor
		origin = {unpack(arg[1].Origin)}
		dimension = {unpack(arg[1].Dimension)}
	elseif arg.n == 2 then
		origin = arg[1]
		dimension = arg[2]
	elseif arg.n == 4 then
		origin = {arg[1], arg[2]}
		dimension = {arg[3], arg[4]}
	end

	self:SetRect(origin, dimension)
end

function Rectangle:SetRect(origin, dimension)
	self.Origin = origin
	self.Dimension = dimension

	self.Width = self.Dimension[1]
	self.Height = self.Dimension[2]

	self.Left = self.Origin[1]
	self.Top = self.Origin[2]
	self.Right = self.Left + self.Width
	self.Bottom = self.Top + self.Height

end

function Rectangle.IsEmpty(self)
	return self.Dimesion[1] == 0 or self.Dimension[2] == 0
end

function Rectangle.GetCenter(self)
	local midx = self.Origin[1] + self.Dimension[1]/2
	local midy = self.Origin[2] + self.Dimension[2]/2

	return midx, midy
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

	local origin = {self.Origin[1]-dx/2, self.Origin[2]-dy/2}
	local dimension = {self.Dimension[1]+dx, self.Dimension[2]+dy}
	self:SetRect(origin, dimension)
end

function Rectangle.Offset(self, x, y)
	local origin = {self.Origin[1]+x, self.Origin[2]+y}
	self:SetRect(origin, self.Dimension)
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

function Rectangle.Union(self, other)
	local leftmost = math.min(self.Origin[1], other.Origin[1]);
	local topmost = math.min(self.Origin[2], other.Origin[2]);

	local rightmost = math.max(self.Right, other.Right);
	local bottommost = math.max(self.Bottom, other.Bottom);


	local widest = rightmost - leftmost;
	local highest = bottommost - topmost;

	local arect = Rectangle({leftmost, topmost}, {widest, highest})

	return arect;
end

function Rectangle.__tostring(self)
	return '{'..self.Left..','..self.Top..','..self.Right..','..self.Bottom..'}';
end

Rectangle.Empty = Rectangle();


--[[
local rec = Rectangle({10,10}, {100, 100})
local midx, midy = rec:GetCenter()
print("Center: ", midx, midy)

rec1 = Rectangle(10, 10, 100, 100)
midx, midy = rec1:GetCenter()
print("Center2: ", midx, midy);

--]]
