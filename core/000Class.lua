-- This is a rudimentary implementation of a class
-- Hierarchy mechanism
-- single inheritance
--
-- Use it like:
--  BaseClass = inheritsFrom(nil)
--  SubClass = inheritsFrom(BaseClass)
--
--  sub = SubClass:new(params)
--

function inheritsFrom( baseClass )

    local new_class = {}
    local class_mt = { __index = new_class }

    function new_class:create(newinst)
        newinst = newinst or {}
        setmetatable( newinst, class_mt )
        return newinst
    end

    if nil ~= baseClass then
        setmetatable( new_class, { __index = baseClass } )
    end

    -- Implementation of additional OO properties starts here --

    -- Return the class object of the instance
    function new_class:class()
        return new_class
    end

    -- Return the super class object of the instance
    function new_class:superClass()
        return baseClass
    end

    -- Return true if the caller is an instance of theClass
    function new_class:isa( theClass )
        local b_isa = false

        local cur_class = new_class

        while ( nil ~= cur_class ) and ( false == b_isa ) do
            if cur_class == theClass then
                b_isa = true
            else
                cur_class = cur_class:superClass()
            end
        end

        return b_isa
    end

    return new_class
end

function functor(objstate, func)
	return {objstate, func}
end

function functorcall(func, params)
	return func[2](func[1], params)
end

--[[
class ={
	inheritsFrom,
	functor = functor,
	functorcall = functorcall
	}

return class
--]]
