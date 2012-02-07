require "HeadsUpMenuCommands"

HeadsUpMenuDef = {
    "File",{
        "New", do_new_file,
        "Open", do_file_open,
        "-",nil,
		"Save", do_update_file,
		"Save As...", do_save_file,
		"-",nil,
        "Exit", do_exit,
    },
	"Start", do_start_animation,
	"Stop", do_stop_animation,
	"Help",{
        "About", do_About,
        "Home Page", default,
    },
}
