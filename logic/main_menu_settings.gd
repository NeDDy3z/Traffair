extends Control



const resolutions = {
	"3840 x 2160" : Vector2i(3840,2160),
	"2880 x 1800" : Vector2i(2880,1800),
	"2560 x 1440" : Vector2i(2560,1440),
	"1920 x 1200" : Vector2i(1920,1200),
	"1920 x 1080" : Vector2i(1920,1080),
	"1680 x 1050" : Vector2i(1680,1050),
	"1600 x 900" : Vector2i(1600,900),
	"1280 x 800" : Vector2i(1280,800),
	"1280 x 720" : Vector2i(1280,720)
}
const window_modes = [
	"Fullscreen",
	"Fullscreen-Bordless",
	"Window",
	"Window-Bordless"
]

var file_path : String
var dir_access 
var read
var write

var resolution
var window_mode
var brightness
var debug 



func _ready():
	# Load value Nodes
	resolution = $MarginContainer2/HBoxContainer/VBoxContainer2/resolution_value
	window_mode = $MarginContainer2/HBoxContainer/VBoxContainer2/window_mode
	brightness = $MarginContainer2/HBoxContainer/VBoxContainer2/brightness_box/brightness_value
	debug = $MarginContainer2/HBoxContainer/VBoxContainer2/debug_value
	
	# Add resolution options into resolution-optionbutton
	for res in resolutions:
		resolution.add_item(res)
	
	# Add window modes options into window_mode-optionbutton
	for wm in window_modes:
		window_mode.add_item(wm)
	
	display_settings()
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Load settings from file
func display_settings():
	# Load into selection
	for i in window_mode.item_count:
		if window_mode.get_item_text(i) == Settings.settings_data["window_mode"]:
			window_mode.select(i)
	
	for i in resolution.item_count:
		if resolution.get_item_text(i) == Settings.settings_data["resolution"]:
			resolution.select(i)
	
	brightness.value = Settings.settings_data["brightness"]
	
	if Settings.settings_data["debug"]:
		debug.select(0)
	else:
		debug.select(1)
	
	
	Logger.write_to_log(name, "failed to load settings", "settings file does not exist, applying default settings")
	Logger.write_to_console(name, "failed to load settings", "settings file does not exist, applying default settings")





# Events
func _on_window_mode_item_selected(index):
	# Load selection into variable
	var win = window_mode.get_item_text(index)
	
	# Set window mode
	Settings.settings_data["window_mode"] = win
	Settings.set_window_mode(win)
	
	# Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "window_mode option changed")
	Logger.write_to_console(name, "window_mode option changed")


func _on_resolution_value_item_selected(index):
	# Load selection into variable
	var res = resolution.get_item_text(index)
	
	# Set resolution
	Settings.settings_data["resolution"] = res
	Settings.set_resolution(resolutions.get(res))
	
	# Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "resolution option changed")
	Logger.write_to_console(name, "resolution option changed")


func _on_brightness_value_value_changed(value):
	# Set brightness
	Settings.settings_data["brightness"] = value
	Settings.set_brightness(value)
	
	# Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "brightness option changed")
	Logger.write_to_console(name, "brightness option changed")


func _on_debug_value_item_selected(index):
	# Load debug value into variable
	var item_text = debug.get_item_text(index)
	
	# Check if value is on/off, on = true, off = false
	if item_text.to_lower() == "on":
		Settings.settings_data["debug"] = true
	else:
		Settings.settings_data["debug"] = false
	
	# Set debug
	Settings.set_debug(Settings.settings_data["debug"])
	
	# Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "debug option changed")
	Logger.write_to_console(name, "debug option changed")


# Return to main_menu
func _on_back_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	
	
	Logger.write_to_log(name, "open main_menu")
	Logger.write_to_console(name, "open main_menu")
