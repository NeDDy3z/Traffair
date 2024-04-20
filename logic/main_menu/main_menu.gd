extends Control



var level_selection : Object
var settings : String
var tutorial : String
var bonus : String
var credits : String



# Called when the node enters the scene tree for the first time.
func _ready():
	## Initialize variables
	level_selection = $level_selection
	settings = Global.main_menu_paths["settings"]
	tutorial = Global.main_menu_paths["tutorial"]
	bonus = Global.main_menu_paths["bonus"]
	credits = Global.main_menu_paths["credits"]
	
	## Hide level selection
	level_selection.visible = false
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


## Open level selection on Play [Button] press
func _on_play_pressed():
	level_selection.visible = true
	
	
	Logger.write_to_log(name, "play pressed")
	Logger.write_to_console(name, "play pressed")


## Open Settings [main_menu_settings.tsnc] on Settings [Button] press
func _on_options_pressed():
	get_tree().change_scene_to_file(settings)
	
	
	Logger.write_to_log(name, "open settings")
	Logger.write_to_console(name, "open settings")


## Open tutorial [main_menu_tutorial.tsnc] on Tutorial [Button] press
func _on_tutorial_pressed():
	get_tree().change_scene_to_file(tutorial)
	
	Logger.write_to_log(name, "open tutorial")
	Logger.write_to_console(name, "open tutorial")



## Open bonus content [main_menu_bonus.tsnc] on BonusContent [Button] press
func _on_bonus_pressed():
	get_tree().change_scene_to_file(bonus)
	
	
	Logger.write_to_log(name, "open bonus")
	Logger.write_to_console(name, "open bonus")


## Open credits [main_menu_credits.tsnc] on Credits [Button] press
func _on_credits_pressed():
	get_tree().change_scene_to_file(credits)
	
	
	Logger.write_to_log(name, "open credits")
	Logger.write_to_console(name, "open credits")


## Exit the game Exit [Button] press
func _on_exit_pressed():
	Logger.write_to_log(name, "quit game")
	Logger.write_to_console(name, "quit game")
	
	
	get_tree().quit()
