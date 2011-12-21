function point(x,y,z)
	Processing.DrawPoint(x,y,z)
end



function line(...)
	-- We either have 4, or 5 parameters
	local startPoint = nil
	local endPoint = nil

	if arg.n == 4 then
		startPoint = Vector3D.new(arg[1],arg[2], 0)
		endPoint = Vector3D.new(arg[3], arg[4], 0)
	elseif arg.n == 6 then
		startPoint = Vector3D.new(arg[1],arg[2], arg[3])
		endPoint = Vector3D.new(arg[4], arg[5], arg[6])
	end

--print("Shape.line : ", startPoint, endPoint)
	Processing.DrawLine(startPoint, endPoint)
end

function rect(x, y, width, height)
	Processing.DrawRect(x,y, width, height)
end

function triangle(x1, y1, x2, y2, x3, y3)
	Processing.DrawTriangle(x1, y1, x2, y2, x3, y3)
end

function quad(x1, y1, x2, y2, x3, y3, x4, y4)
	Processing.DrawQuad(x1, y1, x2, y2, x3, y3, x4, y4)
end

function ellipse(centerx, centery, awidth, aheight)
	Processing.DrawEllipse(centerx, centery, awidth, aheight)
end

--[====================================[
--	Curves
--]====================================]



function bezier(x1, y1,  x2, y2,  x3, y3,  x4, y4)
	local curveSteps = 30;
	local pts = {
		{x1, y1, 0},
		{x2, y2, 0},
		{x3, y3, 0},
		{x4, y4, 0}
		}

	local cv4 = cubic_vec3_to_cubic_vec4(pts);

	local lastPoint = bezier_eval(0, cv4);
	for i=1, curveSteps do
		local u = i/curveSteps;
		local cpt = bezier_eval(u, cv4);

		line(lastPoint[1], lastPoint[2], cpt[1], cpt[2])
		lastPoint = cpt;
	end
end

function bezierDetail(...)
end

function bezierPoint(...)
end


function curve(x1, y1,  x2, y2,  x3, y3,  x4, y4)
	local curveSteps = 30;
	local pts = {
		{x1, y1, 0},
		{x2, y2, 0},
		{x3, y3, 0},
		{x4, y4, 0}
		}

	local cv4 = cubic_vec3_to_cubic_vec4(pts);

	local lastPoint = catmull_eval(0, 1/2, cv4);
	for i=1, curveSteps do
		local u = i/curveSteps;
		local cpt = catmull_eval(u, 1/2, cv4);

		line(lastPoint[1], lastPoint[2], cpt[1], cpt[2])
		lastPoint = cpt;
	end
end

function curveDetail(...)
end

function curvePoint(...)
end

function curveTangent(...)

end

function curveTightness(...)
end

-- ATTRIBUTES
function smooth()
	Processing.SetSmooth(true)
end

function noSmooth()
	Processing.SetSmooth(false)
end

function pointSize(ptSize)
	Processing.SetPointSize(ptSize)
end

function strokeWeight(weight)
	Processing.SetStrokeWeight(weight)
end

function size(awidth, aheight, MODE)
	Processing.SetCanvasSize(awidth, aheight, MODE)
end
