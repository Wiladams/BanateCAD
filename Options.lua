--
-- options.lua
--
-- Copyright (c) 2011  Remco Schoeman
--
-- Functionality for loading and saving options
--
-- Supports saving and loading of tables with
-- string keys and string, number and table values.
-- Nested tables are supported.
--
-- by convention the options file is named the same as the lua filename
-- and replacing the '.lua' extension with '.options'
--
-- Usage:

--[[

require("options")

myoptions = Options.load("my.options")

myoptions.theAnswer = 42

myoptions:save() -- saves the options

myoptions:reset() -- resets the values to the default, toplevel added options are not removed

Options.save(myoptions,"my.options.copy")

--]]

--
-- Example of an options file:
--

--[[

-- <filename>
options
{
   option1 = "my first option",
   subsection =
   {
      suboption1 = "my first sub option",
      numoption1 = 0.25,
	  subsubsection =
	  {
	     reallydeepnestedoption = "wow!",
	  },
   },
}

--]]

-- library entry point
Options = {}


-- forward declaration of 'private' functions for this library
local serialize
local isSupportedType

local __genOrderedIndex
local orderedNext
local orderedPairs
local cmp_multitype

-- public functions -----------------------

-- loads an options table from a file
function Options.load(filename)
	assert(filename,"No filename given")
	assert(type(filename) == "string" ,"filename must be a string")

	-- load the options file
	local loadoptions, e = loadfile(filename)
	if not loadoptions then error(e, 2) end

	-- build sandbox environment for the options file
	local opts = {}
	local sandbox =
	{
		-- the options() function copies
		-- the supported options out of the sandbox
		options = function (o)
			for k,v in pairs(o) do
				if "string" == type(k) and isSupportedType(v) then
					opts[k]=v
				end
			end
		end
	}

	-- add utility function to save self
	opts.save = function(self)
		Options.save(self,filename)
	end

    -- utility function to reset to the values
	-- to the defaults
	opts.reset = function(self)
		pcall(loadoptions)
	end

	-- put f in the sandbox and let it play.
	setfenv(loadoptions, sandbox)
	if pcall(loadoptions) then
		return opts
	end
	error("error loading options from " .. filename)
end

-- saves a table as options to the given file
-- it ignores any entries with unsupported key or value types.
function Options.save(opts, filename)
	assert(opts,"No options given")
	assert(type(opts) == "table", "opts must be a table")

	assert(filename,"No filename given")
	assert(type(filename) == "string" , "filename must be a string")

	file = assert(io.open(filename, "w+"))
	file:write("-- " .. filename .. "\n")
	file:write("options")
	serialize(file, opts, "")
	file:write("\n")
	file:close()
end

-- private functions -----------------------

function serialize(file, value, prefix)
    local t = type(value)
	if "number" == t then
		file:write(value)
	elseif "string" == t then
		file:write(string.format("%q", value))
	elseif "table" == t then
		file:write("\n" .. prefix .. "{\n")

		for k,v in orderedPairs(value) do
			if isSupportedType(v) then
				if "string" == type(k) then
					if not k:match("^[%a_][%w_]*$") then
						k = string.format("[%q]",k)
					end
					file:write(prefix, "  ", k, " = ")
					serialize(file, v, prefix .. "  ")
					file:write(",\n")
				elseif "number" == type(k) then
					file:write(prefix, "  ")
					serialize(file, v, prefix .. "  ")
					file:write(",\n")
				end
			end
		end
		file:write(prefix, "}")
	else
		file:write("nil") -- for unsupported value types.
	end
end

function isSupportedType(value)
	t = type(value)
	return t == "table" or t == "number" or t == "string"
end

-- below code has been lifted from http://lua-users.org/wiki/SortedIteration
-- and is used to alphabetically sort the option keys

function cmp_multitype(op1, op2)
    local type1, type2 = type(op1), type(op2)
    if type1 ~= type2 then --cmp by type
        return type1 < type2
    elseif type1 == "number" and type2 == "number"
        or type1 == "string" and type2 == "string" then
        return op1 < op2 --comp by default
    elseif type1 == "boolean" and type2 == "boolean" then
        return op1 == true
    else
        return tostring(op1) < tostring(op2) --cmp by address
    end
end


function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex, cmp_multitype )
    return orderedIndex
end

function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
        return key, t[key]
    end

    -- fetch the next value
    key = nil
    for i = 1,table.getn(t.__orderedIndex) do
        if t.__orderedIndex[i] == state then
            key = t.__orderedIndex[i+1]
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end



