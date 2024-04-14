extends Control


var default_time_scale : float
var current_position : int
var time_scale_stages = [
	1,
	2,
	5,
	10,
	15,
	20
]

var speedup : Object
var pause : Object
var main_menu : String



func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS # The script will work even tho the game is Frozen ("let it go..")
	
	speedup = $HBoxContainer/speedup
	pause = $HBoxContainer/pause
	
	default_time_scale = 1.0
	current_position = 0
	Engine.time_scale = time_scale_stages[0]
	
	main_menu = "res://levels/main_menu/main_menu.tscn"
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Go thru speeds forward
func speed_forwards():
	if current_position == time_scale_stages.size() - 1:
		current_position = 0
	else:
		current_position += 1
		
	Engine.time_scale = time_scale_stages[current_position]
	speedup.text = str(time_scale_stages[current_position]) +"x"
	
	
	Logger.write_to_log(name, "game spedup", time_scale_stages[current_position])
	Logger.write_to_console(name, "game spedup", time_scale_stages[current_position])


# Go thru speeds backwards
func speed_backwards():
	if current_position == 0:
		current_position = time_scale_stages.size() - 1
	else:
		current_position -= 1
		
	Engine.time_scale = time_scale_stages[current_position]
	speedup.text = str(time_scale_stages[current_position]) +"x"
	
	
	Logger.write_to_log(name, "game spedup", time_scale_stages[current_position])
	Logger.write_to_console(name, "game spedup", time_scale_stages[current_position])


# Read input from user
func _unhandled_input(event):
	if (event is InputEventKey
			and event.pressed):
		match event.keycode:
			KEY_ESCAPE:
				pause.set_pressed(!get_tree().paused)
				
				Logger.write_to_log(name, "game paused - ESC", "ingame")
				Logger.write_to_console(name, "game paused - ESC", "ingame")
		 	
			KEY_RIGHT: # On right arrow cycle right
				speed_forwards()
			
			KEY_LEFT: # On left arrow cycle left
				speed_backwards()


# Speedup input - left/right mouse click
func _on_speedup_gui_input(event):
	if (event is InputEventMouseButton
			and event.pressed):
		match event.button_index:
			1: # On left mouse click
				speed_forwards()
			
			2: # On right mouse click
				speed_backwards()


# Pause game - "freeze"
func _on_pause_toggled(toggled_on):
	get_tree().paused = toggled_on
	
	
	Logger.write_to_log(name, "game paused", "ingame")
	Logger.write_to_console(name, "game paused", "ingame")


# Exit game to main menu on Exit click
func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu)
	
	
	Logger.write_to_log(name, "back to menu", "ingame")
	Logger.write_to_console(name, "back to menu", "ingame")
