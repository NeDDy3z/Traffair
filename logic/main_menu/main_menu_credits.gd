extends Control



var godot = "https://godotengine.org/"
var github = "www.github.com/neddy3z/"
var linkedin = "https://www.linkedin.com/in/vanekerik/"



# Called when the node enters the scene tree for the first time.
func _ready():
	$image.texture = load("res://art/chef.png")


## Open Godot's official website in a web browser on Godot [Button] press
func _on_godot_pressed():
	OS.shell_open(godot)


## Open my Github or LinkedIn page on Erik [Button] press
## [LeftMouseButton] opens my Github page
## [RightMouseButton] opens my LinkedIn page
func _on_erik_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			1: ## On [LeftMouseButton] press open github
				OS.shell_open(github)
			2: ## On [RightMouseButton] press open linkedin
				OS.shell_open(linkedin)


## Return to mainMenu [main_menu.tsnc] on BackToMainMenu [Button] press
func _on_back_pressed():
	get_tree().change_scene_to_file(Global.main_menu_paths["main_menu"])
