function createImage(awidth, aheight, dtype)
	local pm = PImage(awidth, aheight, dtype)
	return pm
end

-- Loading and Displaying
--(img, offsetx, offsety, awidth, aheight)
function image(img, x, y, awidth, aheight)
	if img == nil then return end

	Processing.DrawImage(img, x, y, awidth, aheight)
end

function imageMode()
end

function loadImage(filename)
	local pm = PImage(filename)

	return pm
end

function requestImage()
end

function tint()
end

function noTint()
end

-- Pixels
function blend()
end

function copy()
end

function filter()
end

function get()
end

function set()
end

function loadPixels()
end

function pixels()
end

function updatePixels()
end


