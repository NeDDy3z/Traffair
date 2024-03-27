extends Control



var text_label
var log_gd = load("res://logic/log.gd")
var rng = RandomNumberGenerator.new()



func _ready():
	text_label = $text
	
	# Randomly show a hamburgr - friend wanted it
	if rng.randi_range(1, 20) == 1:
		var hamburgr
		var x = rng.randi_range(100, DisplayServer.window_get_size().x - 100)
		var y = rng.randi_range(100, DisplayServer.window_get_size().y - 100)		
		
		hamburgr = Label.new()
		hamburgr.text = "🍔"
		hamburgr.position = Vector2(x,y)
		
		add_child(hamburgr)


# Go back to main menu on button press
func _on_back_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	log_gd.write_to_log("bonus_menu", "open main_menu", "")
	log_gd.write_to_console("bonus_menu", "open main_menu", "")
