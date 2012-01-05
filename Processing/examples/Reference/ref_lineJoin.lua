background(230)

noFill();
smooth();
strokeWeight(10.0);


local pts = {
	{35, 20},
	{65, 50},
	{35, 80},
	}

noFill();
--strokeJoin(cd.MITER);
strokeJoin(cd.ROUND);
Processing.Renderer:DrawPolygon(pts)
