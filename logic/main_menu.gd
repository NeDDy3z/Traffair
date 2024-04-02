extends Control



func _ready():
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")

# Start the game on "play" click
func _on_play_pressed():
	get_tree().change_scene_to_file("res://levels/game_level_kbely.tscn")
	
	
	Logger.write_to_log(name, "play pressed")
	Logger.write_to_console(name, "play pressed")


# Open options on "options" click
func _on_options_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu_settings.tscn")
	
	
	Logger.write_to_log(name, "open settings")
	Logger.write_to_console(name, "open settings")


# Open tutorial menu
func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu_tutorial.tscn")
	
	Logger.write_to_log(name, "open tutorial")
	Logger.write_to_console(name, "open tutorial")



# Open bonus content on "bonus" click
func _on_bonus_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu_bonus.tscn")
	
	
	Logger.write_to_log(name, "open bonus")
	Logger.write_to_console(name, "open bonus")


# Exit game on "exit" click
func _on_exit_pressed():
	Logger.write_to_log(name, "quit game")
	Logger.write_to_console(name, "quit game")
	
	
	get_tree().quit()
