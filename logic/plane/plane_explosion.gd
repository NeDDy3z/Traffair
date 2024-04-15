extends Control



var videoplayer : VideoStreamPlayer
var audioplayer : AudioStreamPlayer
var game_ui : Object



# Called when the node enters the scene tree for the first time.
func _ready():
	videoplayer = VideoStreamPlayer.new()
	audioplayer = AudioStreamPlayer.new()
	game_ui = get_node("../../game_ui")
	
	videoplayer.stream = load("res://resources/videos/explosion.ogv")
	audioplayer.stream = load("res://resources/sounds/explosion.ogg")
	
	videoplayer.expand = true
	videoplayer.size = Vector2(60, 60)
	videoplayer.position = Vector2(-30,-30)
	audioplayer.bus = "SFX"
	
	add_child(videoplayer)
	add_child(audioplayer)
	
	play_effect()
	
	# Destroy self after playing the video
	await videoplayer.finished
	queue_free()
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Play video and sound effect
func play_effect():
	videoplayer.play()
	audioplayer.play()
	game_ui.counter_deduct()
	
	
	Logger.write_to_log(name, "played")
	Logger.write_to_console(name, "played")
