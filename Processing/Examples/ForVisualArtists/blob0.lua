
class.Blob()

function Blob:_init(acx, acy, ar)
	self.cx = acx;
	self.cy = acy;
	self.r = ar;
end

function Blob.render(self)
end

function setup()
	size(600, 400);
	blob0 = Blob(300, 200, 100);
	blob0:render();

	bgcolor = color(0,0,0);

	for y=0, height-1 do
		for x=0, width-1 do
			set(x, y, bgcolor);
		end
	end
end

function draw()
end