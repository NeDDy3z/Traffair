extends Control

var text_label
var log_gd = load("res://logic/log.gd")

func _ready():
	text_label = $text

# Display weather in Prague on "pocasi" click
func _on_pocasi_prg_pressed():
	pass # Replace with function body.

# Go back to main menu on button press
func _on_back_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	log_gd.write_to_log("bonus_menu", "open main_menu", "")
	log_gd.write_to_console("bonus_menu", "open main_menu", "")
