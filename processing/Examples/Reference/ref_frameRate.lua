function setup()
	size(640,480)
  	frameRate(40);
end

local pos = 0;
function draw()
  background(204);
  pos = pos + 1;
  line(pos, 20, pos, 80);
  if(pos > width) then
    pos = 0;
  end
end
