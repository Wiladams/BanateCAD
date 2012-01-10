local lfs = require ("lfs")
local class = require "pl.class"
local app = require 'pl.app'
local path = require 'pl.path'
local utils = require 'pl.utils'


-- add the current script's path to the Lua module path.
-- Applies to both the source and the binary module paths. It makes it easy for
-- the main file of a multi-file program to access its modules in the same directory.
-- @return the current script's path with a trailing slash
function add_require_path(apath)
    --local p = path.dirname(check_script_name())
	local p = apath
    if not path.isabs(p) then
        p = path.join(lfs.currentdir(),p)
    end
    if p:sub(-1,-1) ~= path.sep then
        p = p..path.sep
    end

    local so_ext = path.is_windows and 'dll' or 'so'

    local lsep = package.path:find '^;' and '' or ';'
    local csep = package.cpath:find '^;' and '' or ';'

	local ppath = ('%s?.lua;%s?%sinit.lua%s%s'):format(p,p,path.sep,lsep,package.path)
	local cpath = ('%s?.%s%s%s'):format(p,so_ext,csep,package.cpath)

    package.path = ppath
    package.cpath = cpath

    return p
end



class.BAppContext()

function BAppContext:_init(o)
	o = o or {}		-- create object if user does not provide one

	self.Name = o.Name or "Application"
	self.WorkingDirectory = o.WorkingDirectory or "."
	self.Modules = o.Modules or {}

	self:GotoHomeDirectory()
	app.require_here()

	self:AddRequiredDirectories();

	self:GotoHomeDirectory()

--print("BAppContext:_init, ",package.path)
--print("BAppContext:_init, ",package.cpath)
end

function BAppContext.GotoHomeDirectory(self)
	assert(lfs.chdir(self.WorkingDirectory), "Error setting working directory: "..self.WorkingDirectory)
end

-- Add the specified directories to the module_require
-- path
function BAppContext.AddRequiredDirectories(self)
	for _,moddir in ipairs(self.Modules) do
		add_require_path(moddir)
	end
end

-- Initialize the application context, loading
-- in all the appropriate modules
-- Setting the current working directory
function BAppContext.LoadDirectory(self, dir)
	local filemods = {}

	for filename in lfs.dir(dir) do
		-- load each file that's in that directory
		if string.find(string.upper(filename), ".LUA") ~= nil then
			--print("Loading: ", filename)
			local f, err = loadfile(dir..'/'..filename)
			--print(f, err)
			if f ~= nil then
				--table.insert(filemods, f)
				local ns = f()
			else
				print("Failed to execute")
			end
		end
	end
end

--[[
print("BAppContext.lua - TEST")
local appctx = BAppContext({
	Modules={
		"physics",
		"animation",	-- Animation System
		"codec",		-- Coder/Decoder for files
		"BanateCAD",	-- For BanateCAD specifics
		"UI",
		"Solids",
		"csg",
		"Geometry",
		"core",			-- Guts of the system
		}
	})
--]]

return BAppContext
