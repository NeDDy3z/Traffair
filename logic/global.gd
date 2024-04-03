extends Node



# These serves as a globally accessible variables
var plane_index = 0 # Used for assiging planes their id
var debug = false # Debug stuff - show sprites, ids, spawn somewhere else...



func _ready():
	Logger.write_to_log("Globals", "loaded")
	Logger.write_to_console("Globals", "loaded")
