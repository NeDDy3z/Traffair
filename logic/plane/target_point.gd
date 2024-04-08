extends Node2D



var sprite



# Set visibility of target_point (where planes go towards on their spawn) strictly dev thing
func _ready():
	sprite = $debug_sprite
	
	if Global.debug:
		sprite.visible = true
	else:
		sprite.visible = false
