-- HeadsUpMenuCommands.lua
--
-- Copyright (c) 2012  William Adams
--
-- Menu commands for HeadsUp
--

require "iuplua"

local pather = require "pl.path"


-- Create the main window menu
-- Menu operations
function default (self)
    iup.Message ("Warning", "No operation implemented")
    return iup.DEFAULT
end

function do_About(self)
	iup.Message("About", "HeadsUp (c), February 2012");
	return iup.DEFAULT
end

--==============================================
--	FILE OPERATIONS
--==============================================
function do_file_open(self)
	-- get a filename
	local filename,err = defaultfilemanager:GetOpenFileName();


	if filename == nil then
		return iup.DEFAULT
	end


	-- empty out the current view
	intext.value = ''

	-- Add the script's path to the require list
	-- so that other files can be included from there
	local pathpart, filepart = pather.splitpath(filename);
	add_require_path(pathpart)

--print(filename, err)

	-- open up the file
	local f = io.open(filename, 'r')

	-- read line by line into the input text field
	intext.FORMATTING = "YES"
	for line in f:lines() do
		--intext.INSERT = line;
		intext.APPEND = line;
	end

	-- close the file
	f:close()

	Application.Window:SetFilename(defaultfilemanager.NAME);
end



function do_update_file(self)
	local filename, err = defaultfilemanager:GetSaveFileName();

	if (not filename) then
		return iup.DEFAULT
	end

	-- open up the file to write
	local f = io.open(filename, 'w+');

	f:write(intext.value);

	f:close();

	Application.Window:SetFilename(defaultfilemanager.NAME);
end

function do_save_file(self)
	local filename, err = defaultfilemanager:GetSaveFileName();

	if (not filename) then
		return iup.DEFAULT
	end

	-- open up the file to write
	local f = io.open(filename, 'w+');

	f:write(intext.value);

	f:close();

	Application.Window:SetFilename(defaultfilemanager.NAME);
end

function do_new_file(self)
	intext.value = ''
	defaultfilemanager:SetFileName("NewDesign.fab");

	Application.Window:SetFilename(defaultfilemanager.NAME);
end

function do_exit (self)
    return iup.CLOSE
end



--==============================================
--	RENDERING
--==============================================

function do_compile_and_render(self)
	local inputtext = intext.value

	local f = loadstring(inputtext)
	f()

	-- Call setup if the user has defined a setup function
	if (_G.setup) ~= nil then
		setup()
	end

end

--===================================
-- ANIMATION
--===================================

function do_start_animation(self)
	local inputtext = intext.value

	Processing.Compile(inputtext)
end

function do_stop_animation(self)
	Processing.StopAnimation()
end

--===================================
--	EDIT
--===================================

function do_paste(self)
	--intext.INSERT = "more text";
end

