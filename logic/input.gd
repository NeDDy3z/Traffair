extends Node



var game_ui : Object
var nodes : Array
var is_game_level : bool




# Called when the node enters the scene tree for the first time.
func _ready():
	 ## [PROCESS_MODE_ALWAYS] ensures the script will still work when the game is frozen
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


## Check if scene is a game level
func load_nodes(value : Object = null):
	game_ui = value
	
	nodes = get_parent().get_children()
	for node in nodes:
		if node.name.contains("game_level"):
			is_game_level = true
	
	
	Logger.write_to_log(name, "children nodes loaded")
	Logger.write_to_console(name, "children nodes loaded")


## Read user input
## Do a specific action based on pressed button
func _unhandled_input(event):
	if (
		event is InputEventKey
		and event.pressed
		and is_game_level
	):
		# Match (switch) doesnt work
		if event.is_action_pressed("game_pause"):
			game_ui.controls.pause.set_pressed(!get_tree().paused)
			
			Logger.write_to_log(name, "game pause input")
			Logger.write_to_console(name, "game pause input")
		
		elif event.is_action_pressed("speedup_forward"):
			game_ui.controls.speed_forward()
			
			Logger.write_to_log(name, "speedup_forward input")
			Logger.write_to_console(name, "speedup_forward input")
		
		elif event.is_action_pressed("speedup_backward"):
			game_ui.controls.speed_backward()
			
			Logger.write_to_log(name, "speedup_backward input")
			Logger.write_to_console(name, "speedup_backward input")
		
		elif event.is_action_pressed("plane_altitude"):
			game_ui.description.altitude.grab_focus()
			
			Logger.write_to_log(name, "altitude grab_focus input")
			Logger.write_to_console(name, "altitude grab_focus input")
		
		elif event.is_action_pressed("plane_heading"):
			game_ui.description.heading.grab_focus()
			
			Logger.write_to_log(name, "heading grab_focus input")
			Logger.write_to_console(name, "heading grab_focus input")
		
		elif event.is_action_pressed("plane_speed"):
			game_ui.description.speed.grab_focus()
			
			Logger.write_to_log(name, "speed grab_focus input")
			Logger.write_to_console(name, "speed grab_focus input")
		
		elif event.is_action_pressed("plane_land"):
			game_ui.description.land.set_pressed(true)
			
			Logger.write_to_log(name, "land grab_focus input")
			Logger.write_to_console(name, "land grab_focus input")
		
		elif event.is_action_pressed("plane_hold"):
			game_ui.description.hold.set_pressed(!game_ui.description.hold.toggled)
			
			Logger.write_to_log(name, "hold grab_focus input")
			Logger.write_to_console(name, "hold grab_focus input")

