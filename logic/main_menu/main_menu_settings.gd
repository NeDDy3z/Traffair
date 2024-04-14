extends Control



var resolution : OptionButton
var window_mode : OptionButton
var vsync : OptionButton
var fps : LineEdit
var brightness : HSlider
var brightness_label : Label
var sfx : HSlider
var sfx_label : Label
var music : HSlider
var music_label : Label
var debug : OptionButton
var logging : OptionButton

var main_menu : String



# Called when the node enters the scene tree for the first time.
func _ready():
	# Load value Nodes
	resolution = $MarginContainer/HBoxContainer/VBoxContainer2/resolution_value
	window_mode = $MarginContainer/HBoxContainer/VBoxContainer2/window_mode
	vsync = $MarginContainer/HBoxContainer/VBoxContainer2/vsync_value
	fps = $MarginContainer/HBoxContainer/VBoxContainer2/fps_value
	brightness = $MarginContainer/HBoxContainer/VBoxContainer2/brightness_box/brightness_value
	brightness_label = $MarginContainer/HBoxContainer/VBoxContainer2/brightness_box/brightness_value/brightness_value_label
	sfx = $MarginContainer/HBoxContainer/VBoxContainer2/sfx_box/sfx_value
	sfx_label = $MarginContainer/HBoxContainer/VBoxContainer2/sfx_box/sfx_value/sfx_value_label
	music = $MarginContainer/HBoxContainer/VBoxContainer2/music_box/music_value
	music_label = $MarginContainer/HBoxContainer/VBoxContainer2/music_box/music_value/music_value_label
	debug = $MarginContainer/HBoxContainer/VBoxContainer2/debug_value
	logging = $MarginContainer/HBoxContainer/VBoxContainer2/logging_value
	
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


# Display saved settings in selectors
func display_settings():
	# Window mode
	for i in window_mode.item_count:
		if window_mode.get_item_text(i).to_lower() == Settings.settings_data["window_mode"]:
			window_mode.select(i)
	
	# Resolution
	for i in resolution.item_count:
		if resolution.get_item_text(i).to_lower() == Settings.settings_data["resolution"]:
			resolution.select(i)
	
	# Vsync
	for i in vsync.item_count:
		if vsync.get_item_text(i).to_lower() == Settings.settings_data["vsync"]:
			vsync.select(i)
	
	# max FPS
	fps.text = str(Settings.settings_data["fps"])
	
	# Brightness
	brightness.value = Settings.settings_data["brightness"]
	brightness_label.text = str(Settings.settings_data["brightness"])
	
	# SFX
	sfx.value = Settings.settings_data["sfx"]
	sfx_label.text = str(Settings.settings_data["sfx"])
	
	# Music
	sfx.value = Settings.settings_data["sfx"]
	sfx_label.text = str(Settings.settings_data["sfx"])
	
	# Debug
	if Settings.settings_data["debug"]:
		debug.select(0)
	else:
		debug.select(1)
	
	# Logging
	if Settings.settings_data["logging"]:
		logging.select(0)
	else:
		logging.select(1)
	
	
	disable_resolution_selection()
	
	
	Logger.write_to_log(name, "failed to load settings", "settings file does not exist, applying default settings")
	Logger.write_to_console(name, "failed to load settings", "settings file does not exist, applying default settings")


func disable_resolution_selection():
	# In fullscreen disable resolution selection
	var wm_item
	var wm_text
	
	wm_item = window_mode.get_selected_id()
	wm_text = window_mode.get_item_text(wm_item)
	
	if (wm_text == Settings.window_modes[0] 
			or wm_text == Settings.window_modes[1]):
		resolution.disabled = true
		# Select screen size of the display
		var screen_size
		screen_size = DisplayServer.screen_get_size()
		for i in resolution.item_count:
			if resolution.get_item_text(i).to_lower() == str(screen_size.x) +" x "+ str(screen_size.y):
				resolution.select(i)
	else:
		resolution.disabled = false
		resolution.emit_signal(
			"item_selected", 
			resolution.get_selected_id()
		)



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
	disable_resolution_selection()
	
	
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
	
	
	Logger.write_to_log(name, "brightness value changed")
	Logger.write_to_console(name, "brightness value changed")


func _on_sfx_value_value_changed(value):
	# Set sfx
	Settings.settings_data["sfx"] = value
	Settings.set_sfx(value)
	
	# Set value to label
	sfx_label.text = str(Settings.settings_data["sfx"])
	
	# Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "sfx value changed")
	Logger.write_to_console(name, "sfx value changed")


func _on_music_value_value_changed(value):
	# Set sfx
	Settings.settings_data["music"] = value
	Settings.set_music(value)
	
	# Set value to label
	music_label.text = str(Settings.settings_data["music"])
	
	# Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "music value changed")
	Logger.write_to_console(name, "music value changed")


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


func _on_logging_value_item_selected(index):
	# Load debug value into variable
	var item_text = logging.get_item_text(index)
	
	# Check if value is on/off, on = true, off = false
	if item_text.to_lower() == "on":
		Settings.settings_data["logging"] = true
	else:
		Settings.settings_data["logging"] = false
	
	# Set debug
	Settings.set_logging(Settings.settings_data["logging"])
	
	# Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "debug option changed")
	Logger.write_to_console(name, "debug option changed")


# Return to main_menu
func _on_back_pressed():
	get_tree().change_scene_to_file(main_menu)
	
	
	Logger.write_to_log(name, "open main_menu")
	Logger.write_to_console(name, "open main_menu")
