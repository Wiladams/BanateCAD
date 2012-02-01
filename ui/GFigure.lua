local class = require "pl.class"

require "GShape"

class.GFigure(GShape)

function GFigure:_init(params)
	params = params or {}

	self:super(params)

	self.Shapes = params.Shapes or {}
end

function GFigure:AddShape(ashape)
	table.insert(self.Shapes, ashape)
end

function GFigure:Render(graphPort)
	for _,shape in self.Shapes do
		shape:Render(graphPort);
	end
end




