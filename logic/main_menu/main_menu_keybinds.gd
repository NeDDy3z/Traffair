extends Control


var is_remaping : bool = false
var button_remaping
var action_remaping
var action_names : Dictionary = {
	"game_pause" : "GAME PAUSE",
	"speedup_forward" : "SPEEDUP FORWARD",
	"speedup_backward" : "SPEEDUP BACKWARD",
	"plane_land" : "PLANE LAND",
	"plane_hold" : "PLANE HOLD",
	"plane_altitude" : "PLANE SELECT ALTITUDE",
	"plane_heading" : "PLANE SELECT HEADING",
	"plane_speed" : "PLANE SELECT SPEED"
}

var action_list : Object
var action_tab_prefab : Object
var settings : String



# Called when the node enters the scene tree for the first time.
func _ready():
	## Initialize variables
	action_list = $MarginContainer/action_list
	action_tab_prefab = preload("res://prefabs/keybinds_action.tscn")
	settings = Global.main_menu_paths["settings"]
	
	## Call [code]load_action_list[/code]
	load_action_list()
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


## Load InputMap keys to the action_list [VBoxContainer]
func load_action_list():
	var saved_actions 
	saved_actions = InputMap.get_actions()
	
	for action in saved_actions:
		if (
			not action.contains("ui") 
			and action_names.has(action)
		):
			
			var events 
			events = InputMap.action_get_events(action)
			
			if action_names.has(action):
				var action_tab
				var action_label
				var action_value
				
				action_tab = action_tab_prefab.instantiate()
				action_label = action_tab.get_node("action_label")
				action_value = action_tab.get_node("action_value")
				
				action_label.text = action_names[action]
				action_value.text = events[0].as_text()
				
				## Connect [Button] into one event function
				action_value.pressed.connect(_on_action_value_pressed.bind(action_value, action))
				
				## Add action_tab [Node] to the action_list [VBoxContainer]
				action_list.add_child(action_tab)
				
				## Add separator after speedup_backward action
				if action.contains("speedup_backward"):
					var separator
					separator = action_tab_prefab.instantiate()
					separator.get_node("action_value").disabled = true
					
					action_list.add_child(separator)
	
	
	Logger.write_to_log(name, "inputmap displayed")
	Logger.write_to_console(name, "inputmap displayed")


## Update action_tab data
func update_action_tab(button, event):
	button.text = event.as_text()
	
	
	Logger.write_to_log(name, "action_tab button label updated", event.as_text())
	Logger.write_to_console(name, "action_tab button label updated", event.as_text())



## Set is_remapping 
func set_is_remaping(value : bool):
	is_remaping = value
	
	
	Logger.write_to_log(name, "is remapping", is_remaping)
	Logger.write_to_console(name, "is remapping", is_remaping)


## On action_value [Button] press, set remapping to true and register a user input
func _on_action_value_pressed(button, action):
	set_is_remaping(true)
	button.text = "???"
	
	button_remaping = button
	action_remaping = action
	
	
	Logger.write_to_log(name, "action_tab button pressed")
	Logger.write_to_console(name, "action_tab button pressed")


## If is_remapping is true, read the user input
## After user presses and key, it will be registered and set to the InputMap and called [code]update_action_tab[/code]
func _unhandled_input(event):
	if (
		is_remaping
		and event is InputEventKey
		and event.pressed
	):
		InputMap.action_erase_events(action_remaping)
		InputMap.action_add_event(action_remaping, event)
		
		update_action_tab(button_remaping, event)
		
		is_remaping = false
		
		
		Logger.write_to_log(name, "new action input registered")
		Logger.write_to_console(name, "new action input registered")


## Return to mainMenu [main_menu.tsnc] on BackToMainMenu [Button] press
func _on_back_pressed():
	get_tree().change_scene_to_file(settings)
	
	
	Logger.write_to_log(name, "open main_menu")
	Logger.write_to_console(name, "open main_menu")
