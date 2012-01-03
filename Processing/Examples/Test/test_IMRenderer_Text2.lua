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

	renderer:SetTextAlignment(cd.BASE_LEFT);

	renderer:SetFont("Times, Bold 18");
	renderer:DrawText(0, 20, "Times");

	renderer:SetFont("Calibri", cd.BOLD, 18);
	renderer:DrawText(0, 40, "Calibri");

	renderer:SetFont("Bookman, Bold 18", 0, 18);
	renderer:DrawText(0, 60, "Bookman");


	renderer:SetFont("Blackadder ITC, Bold 18");
	renderer:DrawText(0, 80, "Blackadder ITC");

	renderer:SetFont("Arial", cd.BOLD, 18);
	renderer:DrawText(0, 100, "Arial");

	renderer:SetFont("Helvetica", 0, 18);
	renderer:DrawText(0, 120, "Helvetica");

	renderer:SetFont("Courier, Bold 18");
	renderer:DrawText(0, 140, "Courier");

	renderer:SetFont("Mistral, Bold 18");
	renderer:DrawText(0, 160, "Mistral");

	renderer:SetFont("Quartz, Bold 18");
	renderer:DrawText(0, 180, "Quartz");
	renderer:updatePixels()
	renderer:Render(0,0)
end