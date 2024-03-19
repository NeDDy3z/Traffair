extends Node2D
var gui = load("res://levels/game_ui.tscn")
var game_ui = gui.instantiate()


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().add_child(game_ui)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
