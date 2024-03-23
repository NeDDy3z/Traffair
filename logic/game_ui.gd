extends Control



var log_gd = load("res://logic/log.gd")



func _ready():
	log_gd.write_to_log("game_ui", "loaded", "")
	log_gd.write_to_console("game_ui", "loaded", "")
