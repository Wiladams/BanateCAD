function draw()
	for i=0,99 do
  		local r = random(50)
  		stroke(r*5);
  		line(50, i, 50+r, i);
	end
end