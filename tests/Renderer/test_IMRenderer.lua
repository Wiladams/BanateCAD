local black = Color(0,0,0,255);

function setup()
	size(400,400)
	background(255)

	local renderer = IMRenderer(width, height)

	local acolor = Color(0, 0, 0, 255)
	local bgcolor = Color(127, 127, 0, 255);

	renderer:SetBackgroundColor(bgcolor);
	renderer:Clear();

	renderer:loadPixels()
	for pos = 0, width-1 do
		renderer:set(pos, 0, acolor)
		renderer:set(0, pos, acolor)
	end

	renderer:SetStrokeColor(black);
	renderer:DrawLine(0,0,width-1, width-1);

	renderer:DrawText(10, 10, "Hello, World!");

	renderer:updatePixels()
	renderer:Render(0,0)
end