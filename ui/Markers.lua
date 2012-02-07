local class = require "pl.class"

require "RendererPrimitives"

class.Markers(RendererPrimitives)

--[[
marker_e =
    {
        marker_square,
        marker_diamond,
        marker_circle,
        marker_crossed_circle,
        marker_semiellipse_left,
        marker_semiellipse_right,
        marker_semiellipse_up,
        marker_semiellipse_down,
        marker_triangle_left,
        marker_triangle_right,
        marker_triangle_up,
        marker_triangle_down,
        marker_four_rays,
        marker_cross,
        marker_x,
        marker_dash,
        marker_dot,
        marker_pixel,

    }
--]]

function Markers:_init(params)
	RendererPrimitives:_init(self, params)
end


function Markers.square(graphPort, x, y, r)
end

function diamond(graphPort, x, y, r)
end

function circle(graphPort, x, y, r)
end

function crossed_circle(graphPort, x, y, r)
end

function semiellipse_left(graphPort, x, y, r)
end

function semiellipse_right(graphPort, x, y, r)
end

function semiellipse_up(graphPort, x, y, r)
end

function semiellipse_down(graphPort, x, y, r)
end

function triangle_left(graphPort, x, y, r)
end

function triangle_right(graphPort, x, y, r)
end

function triangle_up(graphPort, x, y, r)
end

function triangle_down(graphPort, x, y, r)
end

function four_rays(graphPort, x, y, r)
end

function cross(graphPort, x, y, r)
end

function xing(graphPort, x, y, r)
end

function dash(graphPort, x, y, r)
end

function dot(graphPort, x, y, r)
end

function pixel(graphPort, x, y, acolor)
end



