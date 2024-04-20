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

const levels : Dictionary = {
	"kbely" : "res://levels/game/game_level_kbely.tscn",
	"ruzyne" : "res://levels/game/game_level_ruzyne.tscn"
}
