extends Control



var description



func _ready():
	description = $description
	
	if !Global.debug:
		description.visible = false
	
	Logger.write_to_log("game_ui", "loaded", "")
	Logger.write_to_console("game_ui", "loaded", "")
