extends Node



var game_ui : Object
var nodes : Array
var is_game_level : bool




# Called when the node enters the scene tree for the first time.
func _ready():
	 ## [PROCESS_MODE_ALWAYS] ensures the script will still work when the game is frozen
	process_mode = Node.PROCESS_MODE_ALWAYS


## Check if scene is a game level
func load_nodes(value : Object = null):
	game_ui = value
	
	nodes = get_parent().get_children()
	for node in nodes:
		if node.name.contains("game_level"):
			is_game_level = true


## Read user input
## Do a specific action based on pressed button
func _unhandled_input(event):
	if event is InputEventKey and event.pressed and is_game_level:
		# Match (switch) doesnt work
		if event.is_action_pressed("game_pause"):
			game_ui.controls.pause.set_pressed(!get_tree().paused)
		
		elif event.is_action_pressed("speedup_forward"):
			game_ui.controls.speed_forward()
		
		elif event.is_action_pressed("speedup_backward"):
			game_ui.controls.speed_backward()
		
		elif event.is_action_pressed("plane_altitude"):
			game_ui.description.altitude.grab_focus()
		
		elif event.is_action_pressed("plane_heading"):
			game_ui.description.heading.grab_focus()
		
		elif event.is_action_pressed("plane_speed"):
			game_ui.description.speed.grab_focus()
		
		elif event.is_action_pressed("plane_land"):
			game_ui.description.land.set_pressed(true)
		
		elif event.is_action_pressed("plane_hold"):
			game_ui.description.hold.set_pressed(!game_ui.description.hold.toggled)
