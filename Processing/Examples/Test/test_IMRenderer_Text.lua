local black = Color(0,0,0,255);

function setup()
	size(400,400)
	background(255)

	local renderer = IMRenderer(width, height)

	local acolor = Color(0, 0, 0, 255)
	local bgcolor = Color(127, 127, 0, 255);

	renderer:loadPixels()
	renderer:SetBackgroundColor(bgcolor);
	renderer:Clear();

	renderer:DrawLine(width/2, 0, width/2, height-1)
	renderer:DrawLine(0, height/2, width-1, height/2);

	renderer:SetTextAlignment(cd.BASE_LEFT);
	renderer:DrawText(width/2, 20, "LEFT");

	renderer:SetTextAlignment(cd.BASE_CENTER);
	renderer:DrawText(width/2, 40, "CENTER");

	renderer:SetTextAlignment(cd.BASE_RIGHT);
	renderer:DrawText(width/2, 60, "RIGHT");

	renderer:SetTextAlignment(cd.NORTH_WEST);
	renderer:DrawText(width/2, height/2, "NORTH WEST");
	renderer:SetTextAlignment(cd.SOUTH_WEST);
	renderer:DrawText(width/2, height/2, "SOUTH WEST");

	renderer:SetTextAlignment(cd.NORTH_EAST);
	renderer:DrawText(width/2, height/2, "NORTH EAST");
	renderer:SetTextAlignment(cd.SOUTH_EAST);
	renderer:DrawText(width/2, height/2, "SOUTH EAST");

	renderer:updatePixels()
	renderer:Render(0,0)
end