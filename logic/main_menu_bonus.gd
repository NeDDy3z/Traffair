extends Control



var text_label
var rng = RandomNumberGenerator.new()



func _ready():
	text_label = $text
	
	random_hamburger()
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Randomly show a hamburgr - friend wanted it
func random_hamburger():
	if rng.randi_range(1, 20) == 1:
		var hamburgr
		var x = rng.randi_range(200, DisplayServer.window_get_size().x - 200)
		var y = rng.randi_range(200, DisplayServer.window_get_size().y - 200)		
		
		hamburgr = Label.new()
		hamburgr.text = "🍔"
		hamburgr.position = Vector2(x,y)
		
		add_child(hamburgr)
		
		
		Logger.write_to_log(name, "random_hamburger()")
		Logger.write_to_console(name, "random_hamburger(")


# Go back to main menu on button press
func _on_back_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	
	
	Logger.write_to_log(name, "open main_menu")
	Logger.write_to_console(name, "open main_menu")
