local class = require "pl.class"

class.LayoutManager()

function LayoutManager:_init(gg, frame)
	self.Frame = frame;
    self.Container = gg;
end

function LayoutManager.ResetLayout(self)
	-- Reset the layout for incremental adding
end

-- self IGraphic trans
function LayoutManager.AddToLayout(self, trans)

end

-- IGraphicGroup gg
function LayoutManager.Layout(self, gg)
	-- Reset the layout
	self:ResetLayout();

	self.Container = gg;

	-- And add each of the children one by one
	for _,graphic in ipairs(gg.GraphicChildren) do
		self:AddToLayout(graphic);
	end
end

LayoutManager.Empty = LayoutManager()
