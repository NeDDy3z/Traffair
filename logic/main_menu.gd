extends Control



var log_gd = load("res://logic/log.gd")



# Start the game on "play" click
func _on_play_pressed():
	get_tree().change_scene_to_file("res://levels/game_level_kbely.tscn")
	log_gd.write_to_log("main_menu", "play pressed", "")
	log_gd.write_to_console("main_menu", "play pressed", "")


# Open options on "options" click
func _on_options_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu_options.tscn")
	log_gd.write_to_log("main_menu", "open options", "")
	log_gd.write_to_console("main_menu", "open options", "")


# Exit game on "exit" click
func _on_exit_pressed():
	log_gd.write_to_log("main_menu", "quit game", "")
	log_gd.write_to_console("main_menu", "quit game", "")
	get_tree().quit()
