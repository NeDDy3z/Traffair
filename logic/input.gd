extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Read input from user
func _unhandled_input(event):
	if (event is InputEventKey
			and event.pressed):
		match event.keycode:
			KEY_LEFT: # On left arrow cycle left
				pass
