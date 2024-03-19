extends Control

# Start the game on "play" click
func _on_play_pressed():
	get_tree().change_scene_to_file("res://levels/game_level_test.tscn")

# Open options on "options" click
func _on_options_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu_options.tscn")

# Exit game on "exit" click
func _on_exit_pressed():
	get_tree().quit()
