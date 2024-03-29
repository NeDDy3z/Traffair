extends Control



func _ready():
	Logger.write_to_log("main_menu", "loaded")
	Logger.write_to_console("main_menu", "loaded")

# Start the game on "play" click
func _on_play_pressed():
	get_tree().change_scene_to_file("res://levels/game_level_kbely.tscn")
	Logger.write_to_log("main_menu", "play pressed")
	Logger.write_to_console("main_menu", "play pressed")


# Open options on "options" click
func _on_options_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu_options.tscn")
	Logger.write_to_log("main_menu", "open options")
	Logger.write_to_console("main_menu", "open options")


# Exit game on "exit" click
func _on_exit_pressed():
	Logger.write_to_log("main_menu", "quit game")
	Logger.write_to_console("main_menu", "quit game")
	get_tree().quit()


# Open bonus content on "bonus" click
func _on_bonus_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu_bonus.tscn")
	Logger.write_to_log("main_menu", "open bonus")
	Logger.write_to_console("main_menu", "open bonus")
