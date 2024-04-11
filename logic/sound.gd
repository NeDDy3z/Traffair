extends Node



var background_player : AudioStreamPlayer
var effects_player : AudioStreamPlayer
var explosion_player


# Called when the node enters the scene tree for the first time.
func _ready():
	background_player = AudioStreamPlayer.new()
	
	
	#background_player.stream = load("res://art/plane/backgroundmusic.ogv")
	
	add_child(background_player)
	#background_player.play()
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Play explosion soundeffect on airplane collision
func play_explosion():
	
	explosion_player.play()
	
	
	Logger.write_to_log(name, "explosion played")
	Logger.write_to_console(name, "explosion played")
