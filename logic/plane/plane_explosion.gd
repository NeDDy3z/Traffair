extends Control



var videoplayer = VideoStreamPlayer.new()
var audioplayer = AudioStreamPlayer.new()
@onready var game_ui = get_node("../../game_ui")



# Called when the node enters the scene tree for the first time.
func _ready():
	videoplayer.stream = load("res://resources/videos/explosion.ogv")
	audioplayer.stream = load("res://resources/sounds/explosion.ogg")
	
	videoplayer.expand = true
	videoplayer.size = Vector2(60, 60)
	videoplayer.position = Vector2(-30,-30)
	audioplayer.bus = "SFX"
	
	add_child(videoplayer)
	add_child(audioplayer)
	
	play_effect()
	
	## Destroy self after playing the video
	await videoplayer.finished
	queue_free()


## Play video and sound effect
func play_effect():
	videoplayer.play()
	audioplayer.play()
	game_ui.counter_deduct()
