function createImage()
end

-- Loading and Displaying
function image(img, x, y, width, height)
	if img == nil then return end

	-- Disable blending, until we figure out the
	-- proper blending function
	gl.Disable(gl.BLEND);

	-- This is the absolute slowest this routine
	-- could be.  Going pixel by pixel, reconstructing
	-- color values along the way.

	-- TODO - use the image as a texture map on a quad
	-- and display the quad.  This should make it very
	-- fast as well as give the ability to stretch and
	-- shrink easily
	for row = 0, img.height-1 do
		for column = 0, img.width-1 do
			local r,g,b,a = img:get(column, row)
			stroke(r,g,b)
			point(x+column, y+row)
		end
	end

	gl.Enable(gl.BLEND);
end

function imageMode()
end

function loadImage(filename)
	local pm = PImage.new(filename)

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


