extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_navigate_pressed():
	pass # Replace with function body.


func _on_riddle_pressed():
	pass # Replace with function body.


func _on_back_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	
	Logger.write_to_log(name, "open main_menu")
	Logger.write_to_console(name, "open main_menu")

