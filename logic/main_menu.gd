extends Control



var game_level
var settings
var tutorial
var bonus
var credits



func _ready():
	game_level = "res://levels/game_level_kbely.tscn"
	settings = "res://levels/main_menu_settings.tscn"
	tutorial = "res://levels/main_menu_tutorial.tscn"
	bonus = "res://levels/main_menu_bonus.tscn"
	credits = "res://levels/main_menu_credits.tscn"
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")

# Start the game on "play" click
func _on_play_pressed():
	get_tree().change_scene_to_file(game_level)
	
	
	Logger.write_to_log(name, "play pressed")
	Logger.write_to_console(name, "play pressed")


# Open options on "options" click
func _on_options_pressed():
	get_tree().change_scene_to_file(settings)
	
	
	Logger.write_to_log(name, "open settings")
	Logger.write_to_console(name, "open settings")


# Open tutorial menu
func _on_tutorial_pressed():
	get_tree().change_scene_to_file(tutorial)
	
	Logger.write_to_log(name, "open tutorial")
	Logger.write_to_console(name, "open tutorial")



# Open bonus content on "bonus" click
func _on_bonus_pressed():
	get_tree().change_scene_to_file(bonus)
	
	
	Logger.write_to_log(name, "open bonus")
	Logger.write_to_console(name, "open bonus")


func _on_credits_pressed():
	get_tree().change_scene_to_file(credits)
	
	
	Logger.write_to_log(name, "open credits")
	Logger.write_to_console(name, "open credits")


# Exit game on "exit" click
func _on_exit_pressed():
	Logger.write_to_log(name, "quit game")
	Logger.write_to_console(name, "quit game")
	
	
	get_tree().quit()


