## Target point is a point at which planes travel towards on their spawn, [br]
## it ensures the planes always travel from outside of the view towards the center of a map (the airport)
extends Node2D



var sprite : Sprite2D



# Called when the node enters the scene tree for the first time.
func _ready():
	## Initialize variables
	sprite = $debug_sprite
	
	## Set a visibility of a [Sprite2D] based on a [Global.debug] : bool variable 
	match Global.debug:
		true:
			sprite.visible = true
		false:
			sprite.visible = false
