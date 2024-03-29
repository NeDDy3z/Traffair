extends Control



var file_path : String
var dir_access 
var read
var write

var settings_data



func _ready():
	# Make "settings" folder if it doesnt exist
	dir_access = DirAccess.open("user://")
	if !dir_access.dir_exists("gamedata"):
		dir_access.make_dir("gamedata")
	
	var datetime 
	datetime = Time.get_datetime_dict_from_system()
	file_path = "user://gamedata/settings"
	
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


func save_settings():
	write = FileAccess.open(file_path, FileAccess.WRITE)
	write.store_line(settings_data)
	write.close()


func _on_resolution_value_item_selected(index):
	pass # Replace with function body.


func _on_fullscreen_value_item_selected(index):
	pass # Replace with function body.


func _on_gamma_value_text_submitted(new_text):
	pass # Replace with function body.


func _on_debug_value_item_selected(index):
	pass # Replace with function body.
