extends Control



var resolution : Object
var window_mode : Object
var vsync : Object
var fps : Object
var brightness : Object
var brightness_label : Object
var debug : Object

var main_menu : String



func _ready():
	# Load value Nodes
	resolution = $MarginContainer/HBoxContainer/VBoxContainer2/resolution_value
	window_mode = $MarginContainer/HBoxContainer/VBoxContainer2/window_mode
	vsync = $MarginContainer/HBoxContainer/VBoxContainer2/vsync_value
	fps = $MarginContainer/HBoxContainer/VBoxContainer2/fps_value
	brightness = $MarginContainer/HBoxContainer/VBoxContainer2/brightness_box/brightness_value
	brightness_label = $MarginContainer/HBoxContainer/VBoxContainer2/brightness_box/brightness_value/brightness_value_label
	debug = $MarginContainer/HBoxContainer/VBoxContainer2/debug_value
	
	main_menu = "res://levels/main_menu/main_menu.tscn"
	
	# Add resolution options into resolution-optionbutton
	for res in Settings.resolutions:
		resolution.add_item(res)
	
	# Add window modes options into window_mode-optionbutton
	for wm in Settings.window_modes:
		window_mode.add_item(wm)
	
	for vs in Settings.vsyncs:
		vsync.add_item(vs)
	
	display_settings()
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Load settings from file to show in value tabs
func display_settings():
	# Load into selection
	for i in window_mode.item_count:
		if window_mode.get_item_text(i).to_lower() == Settings.settings_data["window_mode"]:
			window_mode.select(i)
	
	for i in resolution.item_count:
		if resolution.get_item_text(i).to_lower() == Settings.settings_data["resolution"]:
			resolution.select(i)
	
	for i in vsync.item_count:
		if vsync.get_item_text(i).to_lower() == Settings.settings_data["vsync"]:
			vsync.select(i)
	
	fps.text = str(Settings.settings_data["fps"])
	
	brightness.value = Settings.settings_data["brightness"]
	brightness_label.text = str(Settings.settings_data["brightness"]) # Show value on label
	
	if Settings.settings_data["debug"]:
		debug.select(0)
	else:
		debug.select(1)
	
	
	# In fullscreen disable resolution selection
	var wm_i = window_mode.get_selected_id()
	var wm_t = window_mode.get_item_text(wm_i)
	if wm_t == Settings.window_modes[0] or wm_t == Settings.window_modes[1]:
		resolution.disabled = true
		# Select screen size of the display
		var screen_size
		screen_size = DisplayServer.screen_get_size()
		for i in resolution.item_count:
			if resolution.get_item_text(i).to_lower() == str(screen_size.x) +" x "+ str(screen_size.y):
				resolution.select(i)
	else:
		resolution.disabled = false
	
	
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
	
	# Refresh resolution
	Settings.set_resolution(Settings.settings_data["resolution"])
	
	# In fullscreen disable resolution because it doesnt do a thing
	if (win == Settings.window_modes[0] 
			or win == Settings.window_modes[1]):
		resolution.disabled = true
		
		# Select screen size of the display
		var screen_size
		screen_size = DisplayServer.screen_get_size()
		for i in resolution.item_count:
			if resolution.get_item_text(i).to_lower() == str(screen_size.x) +" x "+ str(screen_size.y):
				resolution.select(i)
	else:
		resolution.disabled = false
		resolution.emit_signal("item_selected", resolution.get_selected_id())

	
	Logger.write_to_log(name, "window_mode option changed")
	Logger.write_to_console(name, "window_mode option changed")


func _on_resolution_value_item_selected(index):
	# Load selection into variable
	var res = resolution.get_item_text(index)
	
	# Set resolution
	Settings.settings_data["resolution"] = res
	Settings.set_resolution(Settings.resolutions.get(res))
	
	# Save new settings
	Settings.write_settings()
	
	# Refresh window mode
	Settings.set_window_mode(Settings.settings_data["window_mode"])
	
	
	Logger.write_to_log(name, "vsync option changed")
	Logger.write_to_console(name, "vsync option changed")


func _on_vsync_value_item_selected(index):
	# Load selection into variable
	var vnc = vsync.get_item_text(index)
	
	# Set resolution
	Settings.settings_data["vsync"] = vnc
	Settings.set_vsync(vnc)
	
	# Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "resolution option changed")
	Logger.write_to_console(name, "resolution option changed")


func _on_fps_value_text_submitted(new_text):
	new_text = int(new_text)
	if (new_text < 30 
			or new_text > 999):
		new_text = str(Settings.settings_data["fps"])
		fps.text = new_text
	
	# Set fps
	Settings.settings_data["fps"] = int(new_text)
	Settings.set_fps(int(new_text))
	
	# Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "fps value changed")
	Logger.write_to_console(name, "fps value changed")


func _on_brightness_value_value_changed(value):
	# Prevent darkness (0 made availabe because of design reason)
	if value == 0:
		value = 0.1
	
	# Set brightness
	Settings.settings_data["brightness"] = value
	Settings.set_brightness(value)
	
	# Set value to label
	brightness_label.text = str(Settings.settings_data["brightness"])
	
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
