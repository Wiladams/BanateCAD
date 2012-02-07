--[[
    "Extremely Fast Line Algorithm"

	@author Po-Han Lin (original version: http://www.edepot.com/algorithm.html)
	@author William Adams (HeadsUp port)
	@param x X component of the start point
	@param y Y component of the start point
	@param x2 X component of the end point
	@param y2 Y component of the end point
	@param color Color of the line
	@param surface Bitmap to draw on
--]]

function efla(x1, y1, x2, y2, surface, acolor)
	local yLonger = false;
	local incrementVal = 0;
	local endVal = 0;

	local shortLen = y2-y1;
	local longLen = x2-x1;

	if (math.abs(shortLen) > math.abs(longLen)) then
		local swap = shortLen;
		shortLen = longLen;
		longLen = swap;
		yLonger = true;
	end

	endVal = longLen;

	if (longLen<0) then
		incrementVal = -1;
		longLen = -longLen;
	else
		incrementVal = 1;
	end

	local decInc = 0;

	if longLen == 0 then
		decInc = shortLen;
	else
		decInc = (shortLen/longLen);
	end

	local j = 0.0;
	if yLonger then
		for i=0,endVal,incrementVal do
			surface:set(x1+j, y1+i, acolor);
			j = j + decInc;
		end
	else
		for i=0, endVal, incrementVal do
			surface:set(x1+i, y1+j, acolor);
			j = j+decInc;
		end
	end
end

