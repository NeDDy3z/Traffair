extends Control



func _on_back_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	Logger.write_to_log("options_menu", "open main_menu")
	Logger.write_to_console("options_menu", "open main_menu")
