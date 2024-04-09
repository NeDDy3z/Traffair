extends Control



var videoplayer : VideoStreamPlayer
var game_ui : Object



# Called when the node enters the scene tree for the first time.
func _ready():
	videoplayer = $VideoStreamPlayer
	game_ui = get_node("../../game_ui")

	play_effect()
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Play video and sound effect
func play_effect():
	videoplayer.play()
	Sound.play_explosion()
	game_ui.counter_deduct()
	
	
	Logger.write_to_log(name, "played")
	Logger.write_to_console(name, "played")
