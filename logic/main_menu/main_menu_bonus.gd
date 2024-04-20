extends Control



var text_label : Label
var rng : RandomNumberGenerator

var main_menu : String



# Called when the node enters the scene tree for the first time.
func _ready():
	## Initialize variables
	text_label = $text
	rng = RandomNumberGenerator.new()
	main_menu = Global.main_menu_paths["main_menu"]
	
	## Call [code]random_hamburger[/code]
	random_hamburger()
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


## There's a 20% chance that the hamburger emoji "🍔" will appear on the screen
func random_hamburger():
	if rng.randi_range(1, 20) == 1:
		var hamburgr
		## Choose random position
		var x = rng.randi_range(200, DisplayServer.window_get_size().x - 200)
		var y = rng.randi_range(200, DisplayServer.window_get_size().y - 200)
		
		## Create a new variable and set it the emoji value
		hamburgr = Label.new()
		hamburgr.text = "🍔"
		hamburgr.position = Vector2(x,y)
		
		## Add hamburgr [Node] to the tree
		add_child(hamburgr)
		
		
		Logger.write_to_log(name, "random_hamburger()")
		Logger.write_to_console(name, "random_hamburger(")


## Return to mainMenu [main_menu.tsnc] on BackToMainMenu [Button] press
func _on_back_pressed():
	get_tree().change_scene_to_file(main_menu)
	
	
	Logger.write_to_log(name, "open main_menu")
	Logger.write_to_console(name, "open main_menu")
