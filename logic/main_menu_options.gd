extends Control

func _on_back_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	print("main menu - open main menu")
