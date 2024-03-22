extends Control
var gui = load("res://levels/game_ui.tscn")
var game_ui = gui.instantiate()


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(game_ui)
	print(str(game_ui) +"- added")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




