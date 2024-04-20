extends Control



var default_time_scale : float = 1
var current_position : int = 0
var time_scale_stages = [
	1,
	2,
	5,
	10,
	15,
	20
]

@onready var speedup = $HBoxContainer/speedup
@onready var pause = $HBoxContainer/pause



# Called when the node enters the scene tree for the first time.
func _ready():
	 ## [PROCESS_MODE_ALWAYS] ensures the script will still work when the game is frozen
	process_mode = Node.PROCESS_MODE_ALWAYS 
	Engine.time_scale = time_scale_stages[0]
	main_menu 


## Cycle through time speeds [time_scale_stages] forward
func speed_forward():
	if current_position == time_scale_stages.size() - 1:
		current_position = 0
	else:
		current_position += 1
		
	Engine.time_scale = time_scale_stages[current_position]
	speedup.text = str(time_scale_stages[current_position]) +"x"


## Cycle through time speeds [time_scale_stages] backward
func speed_backward():
	if current_position == 0:
		current_position = time_scale_stages.size() - 1
	else:
		current_position -= 1
		
	Engine.time_scale = time_scale_stages[current_position]
	speedup.text = str(time_scale_stages[current_position]) +"x"


## Speedup mouse input
func _on_speedup_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			1: ## On [LeftMouseButton]
				speed_forward()
			2: ## On [RightMouseButton]
				speed_backward()


## On Pause [Button] toggled pause a game - Freeze 
func _on_pause_toggled(toggled_on):
	get_tree().paused = toggled_on


## On exit [Button] press return to [main_menu]
func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(Global.main_menu_paths["main_menu"])
