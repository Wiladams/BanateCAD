--
-- PrimaryAxes.wlua
--
-- A graphic to display the primary axes
-- Copyright (c) 2011  William Adams
--

PrimaryAxes = {}
function PrimaryAxes:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	o.LINEWIDTH = 1;
	o.COLOR = {0.5, 0.5, 0.5, 1};
	o.LENGTH = 50;

	return o
end

function PrimaryAxes.SetViewerDistance(self, distance)
	self.LENGTH = distance/10;
end

function PrimaryAxes.Draw(self)
	-- Use cross_Hair_COLOR
	gl.LineWidth(self.LINEWIDTH);
	gl.Color(self.COLOR[1], self.COLOR[2], self.COLOR[3], self.COLOR[4]);

	gl.Begin(gl.LINES);
		gl.Vertex(-self.LENGTH, 0, 0);
		gl.Vertex(self.LENGTH, 0, 0);
		gl.Vertex(0, -self.LENGTH, 0);
		gl.Vertex(0, self.LENGTH, 0);
		gl.Vertex(0, 0, -self.LENGTH);
		gl.Vertex(0, 0, self.LENGTH);
	gl.End();
end
