require ("Class")



-- Create a base class, Shape
Shape = inheritsFrom(nil);

-- The primary function of a shape
function Shape.Render(self, renderer)
end

function Shape.Update(self, toTime)
	print("Shape.Update: ", toTime)
end

function Shape.ToString(self)
	return "Shape"
end


--====================================
--	USEFUL FUNCTIONS
--====================================
function sortvertices(v1, v2)
	local xmin = math.min(v1[1], v2[1])
	local xmax = math.max(v1[1], v2[1])

	local ymin = math.min(v1[2], v2[2])
	local ymax = math.max(v1[2], v2[2])

	local zmin = math.min(v1[3], v2[3])
	local zmax = math.max(v1[3], v2[3])

	return {xmin,ymin,zmin}, {xmax, ymax, zmax}
end
