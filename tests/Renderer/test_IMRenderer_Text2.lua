local black = Color(0,0,0,255);

function setup()
	size(400,400)

	local acolor = Color(0, 0, 0, 255)
	local bgcolor = Color(127, 127, 0, 255);

	background(bgcolor);

	Processing.Renderer:SetTextAlignment(cd.BASE_LEFT);

	textFont("Times, 18");
	text(0, 20, "Times");

	textFont("Calibri, Bold, 18");
	text(0, 40, "Calibri");

	textFont("Bookman, Bold 18");
	text(0, 60, "Bookman");

	textFont("Blackadder ITC, Bold 18");
	text(0, 80, "Blackadder ITC");

	textFont("Arial, 18");
	text(0, 100, "Arial");

	textFont("Helvetica, 18");
	text(0, 120, "Helvetica");

	textFont("Courier, 18");
	text(0, 140, "Courier");

	textFont("Mistral, 18");
	text(0, 160, "Mistral");

	textFont("Quartz, 18");
	text(0, 180, "Quartz");
end