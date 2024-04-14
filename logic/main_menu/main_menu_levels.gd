extends Control



var ruzyne : String
var kbely : String



# Called when the node enters the scene tree for the first time.
func _ready():
	ruzyne = "res://levels/game/game_level_ruzyne.tscn"
	kbely = "res://levels/game/game_level_kbely.tscn"
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Start Ruzyne level on ruzyne selection
func _on_ruzyne_button_pressed():
	get_tree().change_scene_to_file(ruzyne)
	
	
	Logger.write_to_log(name, "ruzyne selected")
	Logger.write_to_console(name, "ruzyne selected")


# Start Kbely level on kbely selection
func _on_kbely_button_pressed():
	get_tree().change_scene_to_file(kbely)
	
	
	Logger.write_to_log(name, "kbely selected")
	Logger.write_to_console(name, "kbely selected")


func _on_draw():
	Logger.write_to_log(name, "level selection opened")
	Logger.write_to_console(name, "level selection opened")


func _on_close_pressed():
	self.visible = false
	
	
	Logger.write_to_log(name, "level selection closed")
	Logger.write_to_console(name, "level selection closed")
