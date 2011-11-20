-- metaball.lua
--
-- BanateCAD
-- Copyright (c) 2011  William Adams
--

-- metaball - x, y, z, radius
function  MBInfluence(x, y, z, mball)
	local x2 = (x-mball[1])*(x-mball[1]);
	local y2 = (y-mball[2])*(y-mball[2]);
	local z2 = (z-mball[3])*(z-mball[3]);

	return (mball[4] / math.sqrt(x2 + y2 + z2));
end

-- Another influence function
-- http://www.geisswerks.com/ryan/BLOBS/blobs.html

-- g(r) = 6r^5 - 15r^4 + 10r^3
-- g(r) = r * r * r * (r * (r * 6 - 15) + 10)

function SumInfluence(x,y,z, ballList)
	local sum = 0;

	for i,ball in ipairs(ballList) do
		sum = sum + MBInfluence(x,y,z, ball)
	end
	return sum;
end

-- An iterator version
function IterateMetaballs(ballList, area, spu)
	if spu == nil then spu = {1,1,1} end

	local xincr = 1/spu[1];
	local yincr = 1/spu[2];
	local zincr = 1/spu[3];

	local AREA_WIDTH = area[1]/2;
	local AREA_HEIGHT = area[2]/2;
	local AREA_DEPTH = area[3]/2;

	local MIN_THRESHOLD = 0.98;
	local MAX_THRESHOLD = 1.02;
	sum = 0;
	x = -AREA_WIDTH;
	y = -AREA_HEIGHT;
	z = -AREA_DEPTH;

	return function()
		found = false;

		while found == false do
			x = x+xincr;
			if x >= AREA_WIDTH then
				x = -AREA_WIDTH;
				y = y+yincr;
				if y >= AREA_HEIGHT then
					y = -AREA_HEIGHT;
					z = z+zincr;
					if z >= AREA_DEPTH then
						return nil
					end
				end
			end

			sum = SumInfluence(x,y,z, ballList);
			if sum > MIN_THRESHOLD and sum < MAX_THRESHOLD then
				return {x,y,z};
			end
		end
	end
end

