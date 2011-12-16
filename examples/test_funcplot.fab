function g1(r)
return  r * r * r * (r * (r * 6 - 15) + 10)
end

function g2(r)
return  r * r 
end

function plotfunction(func)
	local radius = 1
	local steps = 100

	for i=0,steps do
		local u = i/steps

		translate({radius*u, func(radius*u), 0})
		tetrahedron(0.05)
	end
end

plotfunction(g1)
plotfunction(g2)