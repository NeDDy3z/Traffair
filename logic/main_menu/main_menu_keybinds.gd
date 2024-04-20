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
var action_tab_prefab = preload("res://prefabs/keybinds_action.tscn")

@onready var action_list = $MarginContainer/action_list



# Called when the node enters the scene tree for the first time.
func _ready():
	## Call [code]load_action_list[/code]
	load_action_list()


## Load InputMap keys to the action_list [VBoxContainer]
func load_action_list():
	var saved_actions = InputMap.get_actions()
	
	for action in saved_actions:
		if not action.contains("ui") and action_names.has(action):
			var events = InputMap.action_get_events(action)
			
			if action_names.has(action):
				var action_tab = action_tab_prefab.instantiate()
				var action_label = action_tab.get_node("action_label")
				var action_value = action_tab.get_node("action_value")
				
				action_label.text = action_names[action]
				action_value.text = events[0].as_text()
				
				## Connect [Button] into one event function
				action_value.pressed.connect(_on_action_value_pressed.bind(action_value, action))
				
				## Add action_tab [Node] to the action_list [VBoxContainer]
				action_list.add_child(action_tab)
				
				## Add separator after speedup_backward action
				if action.contains("speedup_backward"):
					var separator = action_tab_prefab.instantiate()
					separator.get_node("action_value").disabled = true
					
					action_list.add_child(separator)


## Update action_tab data
func update_action_tab(button, event):
	button.text = event.as_text()


## Set is_remapping 
func set_is_remaping(value : bool):
	is_remaping = value


## On action_value [Button] press, set remapping to true and register a user input
func _on_action_value_pressed(button, action):
	set_is_remaping(true)
	button.text = "???"
	
	button_remaping = button
	action_remaping = action


## If is_remapping is true, read the user input
## After user presses and key, it will be registered and set to the InputMap and called [code]update_action_tab[/code]
func _unhandled_input(event):
	if is_remaping and event is InputEventKey and event.pressed:
		InputMap.action_erase_events(action_remaping)
		InputMap.action_add_event(action_remaping, event)
		
		update_action_tab(button_remaping, event)
		
		is_remaping = false


## Return to mainMenu [main_menu.tsnc] on BackToMainMenu [Button] press
func _on_back_pressed():
	get_tree().change_scene_to_file(Global.main_menu_paths["settings"])
