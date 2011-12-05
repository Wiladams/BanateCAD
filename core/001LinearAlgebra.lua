vec = {}
vec.mt = {}

function vec.new(params)
	local _vec = {}
	setmetatable(_vec, vec.mt)
	for i,v in ipairs(params) do
		_vec[i] = v
	end

	return _vec
end

-- Arithmetic overloads
function vec.add(a, b)
	local res = vec.new{}

	for i=1,#a do
		local sum = a[i] + b[i]
		table.insert(res, sum)
	end

	return res
end

function vec.sub(a, b)
	local res = vec.new{}

	for i=1,#a do
		local diff = a[i] - b[i]
		table.insert(res, diff)
	end

	return res
end

function vec.mults(v,s)
	local res = vec.new{}
	res[1] = v[1]*s
	res[2] = v[2]*s
	res[3] = v[3]*s
end

function vec.mul(a, b)
	local res = vec.new{}
	local bnumber = type(b) == 'number'
	local anumber = type(a) == 'number'

	if bnumber then
		for i=1,#a do
			local f = a[i] * b
			table.insert(res, f)
		end
	elseif anumber then
		for i=1,#b do
			local f = b[i] * a
			table.insert(res, f)
		end
	else
		for i=1,#a do
			local f = a[i] * b[i]
			table.insert(res, f)
		end
	end

	return res
end

function vec.div(a, b)
	local res = vec.new{}
	local bnumber = type(b) == 'number'
	local anumber = type(a) == 'number'

	if bnumber then
		for i=1,#a do
			local f = a[i] / b
			table.insert(res, f)
		end
	elseif anumber then
		for i=1,#b do
			local f = b[i] / a
			table.insert(res, f)
		end
	else
		for i=1,#a do
			local f = a[i] / b[i]
			table.insert(res, f)
		end
	end

	return res
end

--
function vec.length(x)
	local sum = 0
	for i=1,#x do
		sum = sum + (x[i]*x[i])
	end

	local f = sqrt(sum)

	return f
end

-- Convenience functions
function vec.tostring (self)
      local s = "{"
      local sep = ""
      for i=1,#self do
        s = s .. sep .. self[i]
        sep = ", "
      end
      return s .. "}"
end

function vec.print (s)
	print(vec.tostring(s))
end

-- Setup the meta methods
vec.mt.__add = vec.add
vec.mt.__div = vec.div
vec.mt.__sub = vec.sub
vec.mt.__mul = vec.mul
vec.mt.__tostring = vec.tostring

vec.Zero = vec.new({0,0,0})








--[[
--Quick Tests
v1 = vec.new{1,0,0}
v2 = vec.new{2,3, 4}

v3 = v1 + v2
v4 = v1 - v2

print(v3)
print(v4)

v5 = v2 * 2
v6 = 2 * v2

print(v5)
print(v6)

print(v6/2)
--]]
