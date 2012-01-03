local class = require "pl.class"
local Img = nil

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

				local ix = x;
				local iy = y;
				local oldColor = Img:get(ix, iy)
				local newRed = (255*h) + oldColor.R;
				local newGrn = (255*h) + oldColor.G;
				local newBlu = oldColor.B
				Img:set(x, y, color(newRed, newGrn, newBlu));
			end
		end
	end
end



function setup()
	size(600, 400);

	local bg = Color(0,64,128,255);
	--Img = createImage(width, height, RGB);
	--Img = PixelArray(width, height, bg);
	Img:loadPixels();

	bgcolor = color(0,0,0);

	for y=0, height-1 do
		for x=0, width-1 do
			Img:set(x, y, bgcolor);
		end
	end

	local blob0 = Blob(300, 200, 100);
	local blob1 = Blob(400, 230, 75);

	Img:loadPixels()
	blob0:render();
	blob1:render();
	Img:updatePixels();

	Img:Render();
	--image(Img, 0, 0)
end

function draw()
end