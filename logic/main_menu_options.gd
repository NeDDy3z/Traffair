extends Control



var file_path : String
var dir_access 
var read
var write

var settings_data
var settings_data_default = {
	"resolution" : "1920x1080",
	"fullscreen" : true,
	"gamma" : 5,
	"debug" : false
}

var resolution
var fullscreen
var gamma
var debug 


func _ready():
	# Set file_path of settings file
	file_path = "user://saves/settings.conf"
	
	resolution = $MarginContainer2/HBoxContainer/VBoxContainer2/resolution_value
	fullscreen = $MarginContainer2/HBoxContainer/VBoxContainer2/fullscreen_value
	gamma = $MarginContainer2/HBoxContainer/VBoxContainer2/gamma_value
	debug = $MarginContainer2/HBoxContainer/VBoxContainer2/debug_value
	
	# Make "settings" folder if it doesnt exist
	dir_access = DirAccess.open("user://")
	if !dir_access.dir_exists("saves"):
		dir_access.make_dir("saves")
		if not FileAccess.file_exists("user://saves/settings.conf"):
			save_settings(settings_data_default)
	
	load_settings()
	
	Logger.write_to_log("options_menu", "loaded")
	Logger.write_to_console("options_menu", "loaded")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	Logger.write_to_log("options_menu", "open main_menu")
	Logger.write_to_console("options_menu", "open main_menu")


func load_settings():
	read = FileAccess.open(file_path, FileAccess.READ)
	if read != null:
		settings_data = read.get_as_text()


func save_settings(value):
	var storable_value = JSON.stringify(value)
	
	write = FileAccess.open(file_path, FileAccess.WRITE)
	write.store_line("storable_value")
	write.close()


func _on_resolution_value_item_selected(index):
	pass # Replace with function body.


func _on_fullscreen_value_item_selected(index):
	pass # Replace with function body.


func _on_gamma_value_text_submitted(new_text):
	pass # Replace with function body.


func _on_debug_value_item_selected(index):
	pass # Replace with function body.
