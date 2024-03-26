class_name Global
extends Node



var log_gd = load("res://logic/log.gd")



# These serves as a globally accessible variables
var plane_index = 0 # Used for assiging planes their id
var debug = false # Debug stuff - show sprites, ids, spawn somewhere else...

func _ready():
	log_gd.write_to_log("Globals", "loaded", "")
	log_gd.write_to_console("Globals", "loaded", "")
