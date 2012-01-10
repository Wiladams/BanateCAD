local no_mat = {0,0,0,1}
local mat_ambient = {0.7, 0.7, 0.7, 1.0}
local mat_ambient_color = {0.8, 0.8, 0.2, 1.0}
local mat_diffuse = {0.1, 0.5, 0.8, 1.0}
local mat_specular = {1.0, 1.0, 1.0, 1.0}
local no_shininess = {0}
local low_shininess = {5}
local high_shininess = {100}
local mat_emission = {0.3, 0.2, 0.2, 0}

local mat1 = BMaterial.new({
	Ambient = no_mat,
	Diffuse = mat_diffuse,
	Specular = no_mat,
	Shininess = no_shininess,
	Emission = no_mat
	})

local mat2 = BMaterial.new({
	Ambient = no_mat,
	Diffuse = mat_diffuse,
	Specular = mat_specular,
	Shininess = low_shininess,
	Emission = no_mat
	})

local mat3 = BMaterial.new({
	Ambient = no_mat,
	Diffuse = mat_diffuse,
	Specular = mat_specular,
	Shininess = high_shininess,
	Emission = no_mat
	})

local mat4 = BMaterial.new({
	Ambient = no_mat,
	Diffuse = mat_diffuse,
	Specular = no_mat,
	Shininess = no_shininess,
	Emission = mat_emission
	})

local lshape1 = shape_ellipsoid.new({XRadius = 1,ZRadius = 1, USteps=30, WSteps=30})
lshape1.Material = mat1

local lshape2 = shape_ellipsoid.new({XRadius = 1,ZRadius = 1, USteps=30, WSteps=30})
lshape2.Material = mat2

local lshape3 = shape_ellipsoid.new({XRadius = 1,ZRadius = 1, USteps=30, WSteps=30})
lshape3.Material = mat3

local lshape4 = shape_ellipsoid.new({XRadius = 1,ZRadius = 1, USteps=30, WSteps=30})
lshape4.Material = mat4

color("Blue")

translate({-3.75, 3, 0})
addshape(lshape1)

translate({-1.25, 3, 0})
addshape(lshape2)

translate({1.25, 3, 0})
addshape(lshape3)

translate({3.75, 3, 0})
addshape(lshape4)