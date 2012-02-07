-- Basic vector routines
-- Conversions
function point3h_from_vec3(vec)
	return {vec[1], vec[2], vec[3], 1};
end

function vec3_from_point3h(pt)
	return {pt[1], pt[2], pt[3]};
end

-- Vector addition
function vec2_add(v1, v2)
	return {v1[1]+v2[1], v1[2]+v2[2]}
end

function vec3_add(v1, v2)
	return {v1[1]+v2[1], v1[2]+v2[2], v1[3]+v2[3]}
end

function vec4_add(v1, v2)
	return {v1[1]+v2[1], v1[2]+v2[2], v1[3]+v2[3], v1[4]+v2[4]}
end

-- Vector subtraction
function vec2_sub(v1, v2)
	return {v1[1]-v2[1], v1[2]-v2[2]}
end

function vec3_sub(v1, v2)
	return {v1[1]-v2[1], v1[2]-v2[2], v1[3]-v2[3]}
end

function vec4_sub(v1, v2)
	return {v1[1]-v2[1], v1[2]-v2[2], v1[3]-v2[3], v1[4]-v2[4]}
end

-- Multiply by a scalar
function vec2_mults(v, s)
	return {v[1]*s, v[2]*s}
end

function vec3_mults(v, s)
	return {v[1]*s, v[2]*s, v[3]*s}
end

function vec4_mults(v, s)
	return {v[1]*s, v[2]*s, v[3]*s, v[4]*s}
end

-- Magnitude of a vector
-- Gives the Euclidean norm
function vec3_lengthsquared(v)
	return (v[1]*v[1]+v[2]*v[2]+v[3]*v[3])
end

function vec3_length(v)
	return math.sqrt(vec3_lengthsquared(v))
end

function vec3_norm(v)
	return vec3_mults(v, 1/vec3_length(v))
end

-- Dot Product
function vec3_dot(v1,v2)
	return v1[1]*v2[1]+v1[2]*v2[2]+v1[3]*v2[3]
end

function vec4_dot(v1,v2)
	return v1[1]*v2[1]+v1[2]*v2[2]+v1[3]*v2[3]+v1[4]*v2[4]
end


function vec3_cross(v1, v2)
	return {
		(v1[2]*v2[3])-(v2[2]*v1[3]),
		(v1[3]*v2[1])-(v2[3]*v1[1]),
		(v1[1]*v2[2])-(v2[1]*v1[2])
	}
end
