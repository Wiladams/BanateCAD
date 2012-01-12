row = 1
column = 1
size = 5
width = 10

-- Print out a sphere for each color in the crayola
-- color table
-- This will take a bit of time as the spheres have a fixed 
-- high resolution
for v in pairs(crayola) do
	if type(v) == "string"  and type(crayola[v]) == "table" then
		--print(v)
		color(crayola.rgb(v))
		translate({column*size, row*size, 0})
		dodecahedron(3)
		column = column + 1
		if column > width then
			column = 1
			row = row + 1
		end
	end
end