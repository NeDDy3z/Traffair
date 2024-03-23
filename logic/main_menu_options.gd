extends Control



var log_gd = load("res://logic/log.gd")



func _on_back_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	log_gd.write_to_log("options_menu", "open main_menu", "")
	log_gd.write_to_console("options_menu", "open main_menu", "")
