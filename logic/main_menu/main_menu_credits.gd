extends Control



var godot : String
var github : String
var linkedin : String
var image : Object

var main_menu : String



# Called when the node enters the scene tree for the first time.
func _ready():
	image = $image
	godot = "https://godotengine.org/"
	github = "www.github.com/neddy3z/"
	linkedin = "https://www.linkedin.com/in/vanekerik/"
	
	main_menu = Global.main_menu_paths["main_menu"]
	image.texture = load("res://art/chef.png")
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Open Godot engine website
func _on_godot_pressed():
	OS.shell_open(godot)
	
	
	Logger.write_to_log(name, "open godot website")
	Logger.write_to_console(name, "open godot website")


# Open github/linkedin
func _on_erik_gui_input(event):
	if (
		event is InputEventMouseButton
		and event.pressed
	):
		match event.button_index:
			1: # On left mouse click open github
				OS.shell_open(github)
				
				Logger.write_to_log(name, "open my github page")
				Logger.write_to_console(name, "open my github page")
			
			2: # On right mouse click open linkedin
				OS.shell_open(linkedin)
				
				Logger.write_to_log(name, "open my linkedin page")
				Logger.write_to_console(name, "open my linkedin page")


# Go back to main_menu
func _on_back_pressed():
	get_tree().change_scene_to_file(main_menu)
	
	
	Logger.write_to_log(name, "open main_menu")
	Logger.write_to_console(name, "open main_menu")
