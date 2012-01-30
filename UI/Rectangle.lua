local class = require "pl.class"

class.Rectangle()

function Rectangle:_init(...)
	local extent = {0,0}
	local origin = {0,0}

	if arg.n == 0 then
		self.IsEmpty = true
	elseif arg.n == 1 then
		-- Copy constructor
		origin = {unpack(arg[1].Origin)}
		extent = {unpack(arg[1].Extent)}
	elseif arg.n == 2 then
		origin = arg[1]
		extent = arg[2]
	elseif arg.n == 4 then
		origin = {arg[1], arg[2]}
		extent = {arg[3], arg[4]}
	end

	self:SetRect(origin, extent)
end

function Rectangle:SetRect(origin, extent)
	self.Origin = origin
	self.Extent = extent

	self.Width = self.Extent[1]
	self.Height = self.Extent[2]

	self.Left = self.Origin[1]
	self.Top = self.Origin[2]
	self.Right = self.Left + self.Width
	self.Bottom = self.Top + self.Height

	if self.Width > 0 and self.Height > 0 then
		self.IsEmpty = false
	end
end


function Rectangle.GetCenter(self)
	local midx = self.Origin[1] + self.Extent[1]/2
	local midy = self.Origin[2] + self.Extent[2]/2

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
	if x < self.Origin[1] or y < self.Origin[2] then
		return false
	end

	if x > (self.Origin[1] + self.Extent[1]) or y > (self.Origin[2] + self.Extent[2]) then
		return false
	end

	return true
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

	local origin = {self.Origin[1]-(dx/2), self.Origin[2]-(dy/2)}
	local extent = {self.Extent[1]+dx, self.Extent[2]+dy}

	self:SetRect(origin, extent)
end

function Rectangle.Offset(self, dx, dy)
	local origin = {self.Origin[1]+dx, self.Origin[2]+dy}

	self:SetRect(origin, self.Extent)
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
	if self.IsEmpty then
		return Rectangle(other.Origin, other.Extent)
	end

	local leftmost = math.min(self.Origin[1], other.Origin[1]);
	local topmost = math.min(self.Origin[2], other.Origin[2]);

	local rightmost = math.max(self.Right, other.Right);
	local bottommost = math.max(self.Bottom, other.Bottom);


	local widest = rightmost - leftmost;
	local highest = bottommost - topmost;

	self:SetRect({leftmost, topmost}, {widest, highest})

	return self;
end

function Rectangle.__tostring(self)
	return string.format("{%d,%d},{%d,%d}",
		self.Origin[1], self.Origin[2],
		self.Extent[1], self.Extent[2]);
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
