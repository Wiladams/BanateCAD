require "luagl"

-- Constants

HALF_PI = math.pi / 2
PI = math.pi
QUARTER_PI = math.pi/4
TWO_PI = math.pi * 2

-- Constants related to colors
RGB = 1
HSB = 2


-- for beginShape()
POINTS = gl.POINTS
LINES = gl.LINES
TRIANGLES = gl.TRIANGLES
TRIANGLE_STRIP = gl.TRIANGLE_STRIP
TRIANGLE_FAN = gl.TRIANGLE_FAN
QUADS = gl.QUADS
QUAD_STRIP = gl.QUAD_STRIP

CLOSE = 1

LEFT = 1
CENTER = 2
RIGHT = 4

TOP = 8
BOTTOM = 16
BASELINE = 32

MODEL = 1
SCREEN = 2
SHAPE = 3
