function test_independent()
	import_stl("bowl_12.stl")

	translate({100, 0, 0})
	import_stl("bowl_12.stl")
end

function test_instancing(rows, columns)
	local amesh = import_stl_mesh("bowl_12.stl")

	for row = 1,rows do
		for col = 1,columns do
			color({row/rows, (row+col)/(rows+columns), col/columns, 1})
			translate({col*100-(100*columns/2),row*100-(100*rows)/2,0})
			addmesh(amesh)
		end
	end
end

test_instancing(10,10)