extends Node2D



var sprite


func _ready():
	sprite = $debug_sprite
	
	if Globals.debug:
		sprite.visible = true
	else:
		sprite.visible = false
