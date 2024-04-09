extends Node2D



var sprite : Sprite2D



# Set visibility of target_point (where planes go towards on their spawn) strictly dev thing
func _ready():
	sprite = $debug_sprite
	
	match Global.debug:
		true:
			sprite.visible = true
		false:
			sprite.visible = false
	
	
	Logger.write_to_console(name, "loaded")
	Logger.write_to_log(name, "loaded")
