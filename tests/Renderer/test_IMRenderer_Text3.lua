local black = Color(0,0,0,255);

function setup()
	size(400,400)
	background(230)

	local txt = GText("Times", {50,50}, {FontName = "Times", FontSize=18, Alignment = cd.NORTH_WEST })

	stroke(black)
	txt:render(Processing.Renderer)

	noFill()
	rect(txt.Position[1], txt.Position[2], txt.Size[1], txt.Size[2])
end