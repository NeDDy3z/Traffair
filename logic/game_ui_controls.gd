extends Control


var default_time_scale
var current_position
var time_scale_stages = [
	1,
	5,
	10,
	20,
]

var speedup
var pause



func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS # The script will work even tho the game is Frozen ("let it go..")
	
	speedup = $HBoxContainer/speedup
	pause = $HBoxContainer/pause
	
	default_time_scale = 1.0
	current_position = 0
	
	Logger.write_to_log("game_ui_controls", "loaded")
	Logger.write_to_console("game_ui_controls", "loaded")


# Read input from user
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			pause.set_pressed(!get_tree().paused)
			
			Logger.write_to_log("esc button", "game paused", "ingame")
			Logger.write_to_console("esc button", "game paused", "ingame")


# Exit game to main menu on Exit click
func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	
	Logger.write_to_log("exit button", "back to menu", "ingame")
	Logger.write_to_console("exit button", "back to menu", "ingame")


# Pause game = "freze"
func _on_pause_toggled(toggled_on):
	get_tree().paused = toggled_on
	
	Logger.write_to_log("pause button", "game paused", "ingame")
	Logger.write_to_console("pause button", "game paused", "ingame")


# On press change time scale of the game
func _on_speedup_pressed():
	if current_position == len(time_scale_stages)-1:
		current_position = 0
	else:
		current_position += 1
		
	Engine.time_scale = time_scale_stages[current_position]
	speedup.text = str(time_scale_stages[current_position]) +"x"
