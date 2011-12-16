--[[
	Processing Language skin

	From the Processing Reference: http://processing.org/reference/
--]]

Processing = {
	ColorMode = RGB,
	BackgroundColor = {0.5, 0.5, 0.5, 1},
	FillColor = {1, 1, 1, 1},
	StrokeColor = {0, 0, 0, 1},
	Smooth = false,
}


function Processing.SetColorMode(amode)
	local oldMode = Processing.ColorMode
	Processing.ColorMode = amode

	return oldMode
end

function Processing.SetSmooth(smoothing)
	local graphics = defaultviewer.Renderer
	graphics:SetAntiAlias(smoothing)
end

function Processing.SetBackgroundColor(acolor)
	local oldColor = Processing.BackgroundColor
	Processing.BackgroundColor = acolor

	defaultviewer.colorscheme.BACKGROUND_COLOR = acolor

	--iup.Update(glcanvas);

	return oldColor
end

function Processing.SetFillColor(acolor)
	local oldColor = Processing.FillColor
	Processing.FillColor = acolor
	defaultviewer.Renderer.FillColor = Processing.FillColor

	return oldColor
end

function Processing.SetStrokeColor(acolor)
	local oldColor = Processing.StrokeColor
	Processing.StrokeColor = acolor
	defaultviewer.Renderer.StrokeColor = Processing.StrokeColor

	return oldColor
end

-- Drawing Primitives
function Processing.SetPointSize(ptSize)
	local graphics = defaultviewer.Renderer
	graphics.PointSize = ptSize
end

function Processing.DrawPoint(x,y,z)
	local graphics = defaultviewer.Renderer
	z = z or 0

	local pt = Vector3D.new(x, y, z)
	graphics:DrawPoint(pt)
end

function Processing.DrawLine(startPoint, endPoint)
	defaultviewer.Renderer:DrawLine({startPoint, endPoint, 1})
end

function Processing.DrawRect(x, y, width, height)
	local graphics = defaultviewer.Renderer
	local pts = {
		Vector3D.new{x, y, 0},
		Vector3D.new{x, y+height, 0},
		Vector3D.new{x+width, y+height, 0},
		Vector3D.new{x+width, y, 0},
	}

	graphics:DrawPolygon(pts);

end

function Processing.DrawTriangle(x1, y1, x2, y2, x3, y3)
	local graphics = defaultviewer.Renderer
	local pts = {
		Vector3D.new{x1, y1, 0},
		Vector3D.new{x3, y3, 0},
		Vector3D.new{x2, y2, 0},
	}

	graphics:DrawPolygon(pts);
end

function Processing.DrawQuad(x1, y1, x2, y2, x3, y3, x4, y4)
	local graphics = defaultviewer.Renderer
	local pts = {
		Vector3D.new{x1, y1, 0},
		Vector3D.new{x2, y2, 0},
		Vector3D.new{x3, y3, 0},
		Vector3D.new{x4, y4, 0},
	}

	graphics:DrawPolygon(pts);
end


function Processing.ApplyState()
	Processing.SetBackgroundColor(Processing.BackgroundColor)
	Processing.SetFillColor(Processing.FillColor)
	Processing.SetStrokeColor(Processing.StrokeColor)
	Processing.SetSmooth(Processing.Smooth)
end
