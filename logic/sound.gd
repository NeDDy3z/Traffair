extends Node



var background_player : AudioStreamPlayer
var effects_player : AudioStreamPlayer
var explosion_player



# Called when the node enters the scene tree for the first time.
func _ready():
	background_player = AudioStreamPlayer.new()
	background_player.stream = load("res://resources/sounds/background_music.ogg")
	background_player.bus = "Music"
	
	add_child(background_player)
	play_background()
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Nonstop play
func play_background():
	background_player.play()
	
	await background_player.finished
	play_background()


# Play explosion soundeffect on airplane collision
func play_explosion():
	explosion_player.play()
	
	
	Logger.write_to_log(name, "explosion played")
	Logger.write_to_console(name, "explosion played")
