
class.Blob()

function Blob:_init(acx, acy, ar)
	self.cx = acx;
	self.cy = acy;
	self.r = ar;
end

function Blob.render(self)
	for y = self.cy-self.r, (self.cy+self.r)-1 do
		for x = self.cx-self.r, self.cx+self.r do
			local d = dist(x, y, self.cx, self.cy);
			if (d < self.r) then
				local h = map(d, 0, self.r, 1, 0);
				set(x, y, color(255*h, 255*h, 0));
			end
		end
	end
end

function setup()
	size(600, 400);
	bgcolor = color(0,0,0);
	background(bgcolor);

	local blob0 = Blob(300, 200, 100);

	blob0:render();
end

function draw()
end