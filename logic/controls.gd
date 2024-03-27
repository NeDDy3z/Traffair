extends Control


var default_time_scale

var pause
var log_gd = load("res://logic/log.gd")



func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS # The script will work even tho the game is Frozen ("let it go..")
	
	default_time_scale = 1.0
	pause = $HBoxContainer/pause
	
	log_gd.write_to_log("game_ui_controls", "loaded", "")
	log_gd.write_to_console("game_ui_controls", "loaded", "")


# Read input from user
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			pause.set_pressed(!get_tree().paused)
			
			log_gd.write_to_log("esc button", "game paused", "ingame")
			log_gd.write_to_console("esc button", "game paused", "ingame")


# Exit game to main menu on Exit click
func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	
	log_gd.write_to_log("exit button", "back to menu", "ingame")
	log_gd.write_to_console("exit button", "back to menu", "ingame")


# Pause game = "freze"
func _on_pause_toggled(toggled_on):
	get_tree().paused = toggled_on
	
	log_gd.write_to_log("pause button", "game paused", "ingame")
	log_gd.write_to_console("pause button", "game paused", "ingame")


# Speed up the game on ">>>" click
func _on_speedup_toggled(toggled_on):
	if toggled_on:
		Engine.time_scale = 5.0
	else:
		Engine.time_scale = default_time_scale
