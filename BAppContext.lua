require ("lfs")


BAppContext={}

function BAppContext.new(self, o)
	o = o or {}		-- create object if user does not provide one

	setmetatable(o, self)
	self.__index = self

	o.Name = o.Name or "Application"
	o.WorkingDirectory = o.WorkingDirectory or "."
	o.Modules = o.Modules or {}

	o:Init()

	return o
end

-- Initialize the application context, loading
-- in all the appropriate modules
-- Setting the current working directory
function BAppContext.Init(self)
	assert(lfs.chdir(self.WorkingDirectory), "Error setting working directory: "..self.WorkingDirectory)

	for _,moddir in ipairs(self.Modules) do
		self:LoadDirectory(moddir)
	end
end

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

