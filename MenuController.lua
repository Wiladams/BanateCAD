-- MenuController.lua
--
-- Copyright (c) 2011  William Adams
--
-- Menu commands for BanateCAD
--

require ("iuplua")

require ("FileManager")
require ("STLCodec")
require ("test_lpeg")
require ("CADVM")
require ("SceneBuilder")
require ("AnimationTimer")

MenuController = {}
function MenuController:new(o)
	o = o or {}		-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self

	return o
end

-- Create the main window menu
-- Menu operations
function MenuController.default (self)
    iup.Message ("Warning", "No operation implemented")
    return iup.DEFAULT
end

function MenuController.do_About(self)
	iup.Message("About", "FabuCAD (c) 0.5, November 2011");
	return iup.DEFAULT
end

--==============================================
--	FILE OPERATIONS
--==============================================
function MenuController.do_file_open(self)
	-- get a filename
	local filename,err = defaultfilemanager:GetOpenFileName();


	if filename == nil then
		return iup.DEFAULT
	end

	-- empty out the current view
	intext.value = ''

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

function MenuController.do_import_stl(self)
	-- get a filename
	local filename,err = defaultfilemanager:GetOpenFileName();

	if filename == nil then
		return iup.DEFAULT
	end

		-- open up the file
	local filehandle = io.open(filename, 'r')

	local reader = STLASCIIReader:new({file = filehandle});
	local tmesh = reader:Read();

	-- close the file
	filehandle:close()

	defaultviewer:ClearCachedObjects()
	defaultscene:clear()
	defaultscene:appendCommand(CADVM.mesh(tmesh))

	iup.Update(glcanvas)
end

--	filehandle = io.open(filename, "w+")
--    writer = STLASCIIWriter:new({file = filehandle})
--    writer.WriteMesh(trimesh)
function MenuController.do_export_stl(self)
	-- get a filename
	local filename = "file.stl"
--[[
	local filename,err = defaultfilemanager:GetSaveFileName();

	if filename == nil then
		return iup.DEFAULT
	end
--]]

	-- open up the file
	local f= io.open(filename, 'w+')

print(f)

	local writer = STLASCIIWriter.new({file = f})

	-- Roll through the scene
	-- write out any meshes found in there
	for i, cmd in ipairs(defaultscene.commands) do
		if (cmd.command == CADVM.TRIMESH) then
			writer:WriteMesh(cmd.value, "BanateCAD")
		elseif cmd.command == CADVM.SHAPE then
			local amesh = cmd.value:GetMesh()
			writer:WriteMesh(amesh, "BanateCAD")

		end
	end

	-- close the file
	f:close()
end

function MenuController.do_update_file(self)
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

function MenuController.do_save_file(self)
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

function MenuController.do_new_file(self)
	intext.value = ''
	defaultfilemanager:SetFileName("NewDesign.fab");

	Application.Window:SetFilename(defaultfilemanager.NAME);
end

function MenuController.do_exit (self)
    return iup.CLOSE
end



--==============================================
--	RENDERING
--==============================================


function MenuController.do_compile_and_render(self)
	local inputtext = intext.value

	--print(inputtext)

	defaultscene:clear()

	local f = loadstring(inputtext)
	f()

	iup.Update(glcanvas)
end

function MenuController.do_paste(self)
	--intext.INSERT = "more text";
end

--==============================================
--	VIEW POSITION
--==============================================




function MenuController.do_view_back(self)
	defaultviewer:SetViewBack();
end

function MenuController.do_view_bottom(self)
	defaultviewer:SetViewBottom();
end

function MenuController.do_view_center(self)
	defaultviewer:SetViewCenter()
end

function MenuController.do_view_diagonal(self)
	defaultviewer:SetViewDiagonal()
end

function MenuController.do_view_front(self)
	defaultviewer:SetViewFront()
end

function MenuController.do_view_left(self)
	defaultviewer:SetViewLeft()
end

function MenuController.do_view_right(self)
	defaultviewer:SetViewRight()
end

function MenuController.do_view_top(self)
	defaultviewer:SetViewTop()
end

function MenuController.do_toggle_axes_display(self)
	defaultviewer:ToggleAxesDisplay();
end

--===================================
-- ANIMATION
--===================================
function MenuController.do_start_animation(self)
	AnimationTimer:Start()
end

function MenuController.do_stop_animation(self)
	AnimationTimer:Stop()
end

--==============================================
--	MENU DEFINITION
--==============================================

function MenuController.GetMenuDefinition(self)
local menudef = {
    "File",{
        "New",self.do_new_file,
        "Open",self.do_file_open,
		"Reload", self.default,
        "-",nil,
		"Save", self.do_update_file,
		"Save As...", self.do_save_file,
		"Export",{
			"Export STL", self.do_export_stl,
		},
		"Import",{
			"Import STL", self.do_import_stl,
		},
		"-",nil,
        "Exit",self.do_exit,
    },
    "Edit",{
		"Undo", self.default,
		"Redo", self.default,
		"-", nil,
		"Cut", self.default,
        "Copy",self.default,
        "Paste",self.do_paste,
     },
    "Tools",{
        "Editor",self.default,
		"Console", self.default
    },
	"Compile", {
		"Compile and Render\tF6", self.do_compile_and_render
    },
	"Animation", {
		"Start", self.do_start_animation,
		"Stop", self.do_stop_animation,
    },
	"View",{
		"Show Axes", self.do_toggle_axes_display,
		"-", nil,
        "Top",self.do_view_top,
        "Bottom",self.do_view_bottom,
		"Left", self.do_view_left,
		"Right", self.do_view_right,
		"Front", self.do_view_front,
		"Back", self.do_view_back,
		"Diagonal", self.do_view_diagonal,
		"Center", self.do_view_center,
        "-",nil,
		"Perspective", self.default,
		"Orthographic", self.default,
		"-", nil,
		"Zoom In", self.default,
		"Zoom Out", self.default
    },
	"Help",{
        "About",self.do_About,
        "FabuCAD Home Page",self.default,
    },
}
	return menudef;
end
