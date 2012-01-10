function RECT(x, y, width, height)

	local pts = {
		Vector3D.new{x, y, 0},
		Vector3D.new{x, y+height, 0},
		Vector3D.new{x+width, y+height, 0},
		Vector3D.new{x+width, y, 0},
	}

	--cd.OPEN_LINES
	--cd.CLOSED_LINES
	--cd.FILL
	--cd.CLIP
	--cd.REGION
	--cd.BEZIER

	Processing.DrawPolygon(pts, cd.BEZIER)
end

stroke(0,255,127)
fill(0,255,127)

RECT(10,10,20,20)