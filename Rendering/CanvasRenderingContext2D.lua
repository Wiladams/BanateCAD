-- From the spec
-- http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html#canvasrenderingcontext2d
--

local class = require "pl.class"

class.CanvasRenderingContext2D()

-- Constructor
function CanvasRenderingContext2D:_init(params)
	-- compositing
	self.globalAlpha = 1
	self.globalCompositeOperation = 'source-over'

	-- colors and styles
	self.strokeStyle = 0 -- black
	self.fillStyle = 0	-- black

	-- line caps/joins
	self.lineWidth = 1
	self.lineCap = "butt"	-- butt, round, square
	self.lineJoin = "miter"	-- round, bevel, miter
	self.miterLimit = 10;

	-- shadows
	self.shadowOffsetX = 0
	self.shadowOffsetY = 0
	self.shadowBlur = 0
	self.shadowColor = 0	-- transparent black

	self.font = "10px sans-serif"
	self.textAlign = "start"	-- start, end, left, right, center
	self.textBaseline = "alphabetic" -- top, hanging, middle, alphabetic, ideographic, bottom
end

function CanvasRenderingContext2D:save()
end

function CanvasRenderingContext2D:restore()
end

-- Transformations
function CanvasRenderingContext2D:scale(x, y)
end

function CanvasRenderingContext2D:rotate(angle)
end

function CanvasRenderingContext2D:translate(x, y)
end

function CanvasRenderingContext2D:transform(a, b, c, d, e, f)
end

function CanvasRenderingContext2D:setTransform(a, b, c, d, e, f)
end

-- Colors and Styles
function CanvasRenderingContext2D:creaeteLinearGradient(x0, y0, x1, y1)
end

function CanvasRenderingContext2D:createRadialGradient(x0, y0, r0, x1, y1, r1)
end

-- Image
-- Canvas
-- Video
function CanvasRenderingContext2D:createPattern(image, repetition)
end

-- rects
function CanvasRenderingContext2D:clearRect(x, y, w, h)
end

function CanvasRenderingContext2D:fillRect(x, y, w, h)
end

function CanvasRenderingContext2D:strokeRect(x, y, w, h)
end

-- path API
function CanvasRenderingContext2D:beginPath()
end

function CanvasRenderingContext2D:closePath()
end

function CanvasRenderingContext2D:moveTo(x, y)
end

function CanvasRenderingContext2D:lineTo(x, y)
end

function CanvasRenderingContext2D:quadraticCurveTo(cpx, cpy, x, y)
end

function CanvasRenderingContext2D:bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y)
end

function CanvasRenderingContext2D:arcTo(x1, y1, x2, y2, radius)
end

function CanvasRenderingContext2D:rect(x, y, w, h)
end

function CanvasRenderingContext2D:arc(x, y, radius, startAngle, endAngle, anticlockwise)
end

function CanvasRenderingContext2D:fill()
end

function CanvasRenderingContext2D:stroke()
end

function CanvasRenderingContext2D:drawSystemFocusRing(element)
end

function CanvasRenderingContext2D:drawCustomFocusRing(element)
end

function CanvasRenderingContext2D:scrollPathIntoView()
end

function CanvasRenderingContext2D:clip()
end

function CanvasRenderingContext2D:isPointInPath()
end

-- TEXT
function CanvasRenderingContext2D:fillText(text, x, y, maxWidth)
end

function CanvasRenderingContext2D:strokeText(text, x, y, maxWidth)
end

function CanvasRenderingContext2D:measureText(text)
end


-- Drawing Images
function CanvasRenderingContext2D:drawImage(image, sx, sy, sw, sh, dx, dy, dw, dh)
end

-- Pixel Manipulation
function CanvasRenderingContext2D:createImageData(sw, sh)
end

function CanvasRenderingContext2D:getImageData(sx, sy, sw, sh)
end

function CanvasRenderingContext2D:putImageData(imagedata, dx, dy, dirtyX, dirtyY, dirtyWidth, dirtyHeight)
end



--[[
	STRUCTURES
--]]

--[[
ImageData
	width
	height
	data	-- byte array

TextMetrics
	width

--]]
