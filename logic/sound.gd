extends Node



var background_player : AudioStreamPlayer
var explosion_player : AudioStreamPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	background_player = AudioStreamPlayer.new()
	explosion_player = AudioStreamPlayer.new()
	
	#background_player.stream = load("res://art/plane/explosion.ogv")
	explosion_player.stream = load("res://art/plane/explosion.ogg")
	
	add_child(background_player)
	add_child(explosion_player)
	
	#background_player.play()
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Play explosion soundeffect on airplane collision
func play_explosion():
	explosion_player.play()
	
	
	Logger.write_to_log(name, "explosion played")
	Logger.write_to_console(name, "explosion played")
