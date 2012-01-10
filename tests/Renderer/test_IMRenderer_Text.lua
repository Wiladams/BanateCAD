local black = Color(0,0,0,255);

function setup()
	size(400,400)

	local acolor = Color(0, 0, 0, 255)
	local bgcolor = Color(127, 127, 0, 255);

	background(bgcolor);

	line(width/2, 0, width/2, height-1)
	line(0, height/2, width-1, height/2);

	textFont("Courier")

	Processing.Renderer:SetTextAlignment(cd.BASE_LEFT);
	text(width/2, 20, "LEFT");

	Processing.Renderer:SetTextAlignment(cd.BASE_CENTER);
	text(width/2, 40, "CENTER");

	Processing.Renderer:SetTextAlignment(cd.BASE_RIGHT);
	text(width/2, 60, "RIGHT");

	Processing.Renderer:SetTextAlignment(cd.NORTH_WEST);
	text(width/2, height/2, "NORTH WEST");
	Processing.Renderer:SetTextAlignment(cd.SOUTH_WEST);
	text(width/2, height/2, "SOUTH WEST");

	Processing.Renderer:SetTextAlignment(cd.NORTH_EAST);
	text(width/2, height/2, "NORTH EAST");
	Processing.Renderer:SetTextAlignment(cd.SOUTH_EAST);
	text(width/2, height/2, "SOUTH EAST");
end