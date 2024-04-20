## Singleton of Globally accessible variables
extends Node



var plane_index = 0 ## Counter of planes

var debug : bool = false ## Debug purposes - show sprites, ids, spawn [Plane]s somewhere else, ...
var logging : bool = true 
var log_antispam : bool = true ## Prevents spam of the log

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
