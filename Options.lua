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
		for k,v in pairs(value) do
			if "string" == type(k) and isSupportedType(v) then
				if not k:match("^[%a_][%w_]*$") then
					k = string.format("[%q]",k)
				end
				file:write(prefix, "  ", k, " = ")
				serialize(file, v, prefix .. "  ")
				file:write(",\n")
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




