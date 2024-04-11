extends Control



var main_menu : String



func _ready():
	main_menu = "res://levels/main_menu/main_menu.tscn"

	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Return to main_menu
func _on_back_pressed():
	get_tree().change_scene_to_file(main_menu)
	
	
	Logger.write_to_log(name, "open main_menu")
	Logger.write_to_console(name, "open main_menu")
