extends Node



# These serve as a globally accessible variables
var plane_index = 0 # Used for assiging planes their id
var debug : bool = false # Debug stuff - show sprites, ids, spawn somewhere else...
var logging : bool = true
var log_antispam : bool = true # prevent spamming "direct_to()"



func _ready():
	Logger.write_to_log("Globals", "loaded")
	Logger.write_to_console("Globals", "loaded")
