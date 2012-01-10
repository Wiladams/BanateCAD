-- Create the shape that will be transformed
--local lshape = shape_tetrahedron.new({radius=1})
local lshape = shape_ellipsoid.new({XRadius=5, ZRadius=5})

-- Create an ellipsoid path
local ppath = param_superellipse.new({
	MaxTheta = math.rad(360),
	XRadius = 30,
	ZRadius = 30,
	N=1
	})


-- Create the parametric transformer
local pptransformer = ParamTransformer.new({
	TranslateFunctor = functor(ppath, ppath.GetProfileVertex)
	})

-- Create the shape animator
local sanimator = ShapeAnimator.new({
	Shape = lshape,
	Transformer = pptransformer,
	Period = 15,
	})


addshape(sanimator)

-- Create the Sphere that will be traced upon
sphere(30)

--[[
steps = 360
for i=0, steps do
	local u = i/steps
	local v = sellipse:GetProfileVertex(u)

	translate({v[1], v[2], v[3]})
	color("Blue")
	tetrahedron(0.25)
end
--]]

--defaultviewer.colorscheme = colorschemes.Sunset
