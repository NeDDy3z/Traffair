extends Control



@onready var level_selection = $level_selection



# Called when the node enters the scene tree for the first time.
func _ready():
	## Hide level selection
	level_selection.visible = false


## Open level selection on Play [Button] press
func _on_play_pressed():
	level_selection.visible = true


## Open Settings [main_menu_settings.tsnc] on Settings [Button] press
func _on_options_pressed():
	get_tree().change_scene_to_file(Global.main_menu_paths["settings"])


## Open tutorial [main_menu_tutorial.tsnc] on Tutorial [Button] press
func _on_tutorial_pressed():
	get_tree().change_scene_to_file(Global.main_menu_paths["tutorial"])


## Open credits [main_menu_credits.tsnc] on Credits [Button] press
func _on_credits_pressed():
	get_tree().change_scene_to_file(Global.main_menu_paths["credits"])

## Exit the game Exit [Button] press
func _on_exit_pressed():
	get_tree().quit()
