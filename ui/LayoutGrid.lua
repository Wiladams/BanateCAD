--require "LayoutManager"

local class = require "pl.class"

--class.GridLayout(LayoutManager)
class.LayoutGrid()

-- Origin
-- CellSize
-- CellsWide

function LayoutGrid:_init(params)
	params = params or {
		Origin = {0,0},
		CellSize = {20,20},
		Columns = 4,
		}

	self.Origin = params.Origin or {0,0};
	self.CellSize = params.CellSize or {20,20};
	self.Columns = params.Columns or 4;
end

function LayoutGrid:Layout(members)
	local row = 1
	local col = 1

	for cellNumber,member in ipairs(members) do
		local origin, extent = self:GetCellPosition(col, row)
		member:SetFrame(origin, extent)

		if col >= self.Columns then
			col = 1
			row = row + 1
		else
			col = col + 1
		end
	end
end

function LayoutGrid:GetCellPosition(col, row)
	local posx = self.Origin[1] + ((col-1) * self.CellSize[1])
	local posy = self.Origin[1] + ((row-1) * self.CellSize[2])

	local origin = {posx, posy}
	local extent = {self.CellSize[1], self.CellSize[2]}

	return origin, extent
end


function LayoutGrid:SetActorPosition(actor, col, row)
	local row = 1
	local col = 1

	local origin, extent = self:GetCellPosition(col, row)
	actor:SetFrame(origin, extent)
end

