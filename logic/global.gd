extends Node



# These serve as a globally accessible variables
var plane_index = 0 # Used for assiging planes their id

var debug : bool = false # Debug stuff - show sprites, ids, spawn somewhere else...
var logging : bool = true
var log_antispam : bool = true # prevent spamming "direct_to()"

const main_menu_paths : Dictionary = {
	"main_menu" : "res://levels/main_menu/main_menu.tscn",
	"settings" : "res://levels/main_menu/main_menu_settings.tscn",
	"keybinds" : "res://levels/main_menu/main_menu_keybinds.tscn",
	"tutorial" : "res://levels/main_menu/main_menu_tutorial.tscn",
	"bonus" : "res://levels/main_menu/main_menu_bonus.tscn",
	"credits" : "res://levels/main_menu/main_menu_credits.tscn"
}



# Called when the node enters the scene tree for the first time.
func _ready():
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")
