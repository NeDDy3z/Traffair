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

var keybinds : String
var main_menu : String




## Called when the node enters the scene tree for the first time.
func _ready():
	## Initialize variables
	resolution = $options_container/HBoxContainer/VBoxContainer2/resolution_value
	window_mode = $options_container/HBoxContainer/VBoxContainer2/window_mode
	vsync = $options_container/HBoxContainer/VBoxContainer2/vsync_value
	fps = $options_container/HBoxContainer/VBoxContainer2/fps_value
	brightness = $options_container/HBoxContainer/VBoxContainer2/brightness_box/brightness_value
	brightness_label = $options_container/HBoxContainer/VBoxContainer2/brightness_box/brightness_value/brightness_value_label
	sfx = $options_container/HBoxContainer/VBoxContainer2/sfx_box/sfx_value
	sfx_label = $options_container/HBoxContainer/VBoxContainer2/sfx_box/sfx_value/sfx_value_label
	music = $options_container/HBoxContainer/VBoxContainer2/music_box/music_value
	music_label = $options_container/HBoxContainer/VBoxContainer2/music_box/music_value/music_value_label
	debug = $options_container/HBoxContainer/VBoxContainer2/debug_value
	logging = $options_container/HBoxContainer/VBoxContainer2/logging_value
	
	keybinds = Global.main_menu_paths["keybinds"]
	main_menu = Global.main_menu_paths["main_menu"]
	
	## Add resolution into a resolution_value [OptionButton]
	for res in Settings.resolutions:
		resolution.add_item(res)
	
	## Add window modes into a window_mode_value [OptionButton]
	for wm in Settings.window_modes:
		window_mode.add_item(wm)
	
	## Add vsync modes into a vsync_value [OptionButton]
	for vs in Settings.vsyncs:
		vsync.add_item(vs)
	
	## Call [code]display_settings[/code] to load settings from a saved file
	display_settings()
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


## Set selection into [OptionButton]s based on saved settings in a file
func display_settings():
	## Window Mode
	for i in window_mode.item_count:
		if window_mode.get_item_text(i).to_lower() == Settings.settings_data["window_mode"]:
			window_mode.select(i)
	
	## Resolution
	for i in resolution.item_count:
		if resolution.get_item_text(i).to_lower() == Settings.settings_data["resolution"]:
			resolution.select(i)
	
	## Vsync
	for i in vsync.item_count:
		if vsync.get_item_text(i).to_lower() == Settings.settings_data["vsync"]:
			vsync.select(i)
	
	## max FPS
	fps.text = str(Settings.settings_data["fps"])
	
	## Brightness
	brightness.value = Settings.settings_data["brightness"]
	brightness_label.text = str(Settings.settings_data["brightness"])
	
	## SFX
	sfx.value = Settings.settings_data["sfx"]
	sfx_label.text = str(Settings.settings_data["sfx"])
	
	## Music
	music.value = Settings.settings_data["music"]
	music_label.text = str(Settings.settings_data["music"])
	
	## Debug
	if Settings.settings_data["debug"]:
		debug.select(0)
	else:
		debug.select(1)
	
	## Logging
	if Settings.settings_data["logging"]:
		logging.select(0)
	else:
		logging.select(1)
	
	
	## Call [code]disable_resolution_selection[/code]
	disable_resolution_selection()
	
	
	Logger.write_to_log(name, "display settings")
	Logger.write_to_console(name, "display settings")


## Disable resolution_value [OptionButton] if the game is in Fullscreen mode
func disable_resolution_selection():
	var wm_item
	var wm_text
	
	wm_item = window_mode.get_selected_id()
	wm_text = window_mode.get_item_text(wm_item)
	
	if (
		wm_text == Settings.window_modes[0] 
		or wm_text == Settings.window_modes[1]
	):
		var screen_size
		screen_size = DisplayServer.screen_get_size()
		resolution.disabled = true
		
		for i in resolution.item_count:
			if resolution.get_item_text(i).to_lower() == str(screen_size.x) +" x "+ str(screen_size.y):
				resolution.select(i)
	else:
		resolution.disabled = false
		resolution.emit_signal(
			"item_selected", 
			resolution.get_selected_id()
		)



## On window_mode_value [OptionButton] selection, set the window_mode and save selection into a file
func _on_window_mode_item_selected(index):
	## Initialize variables
	var win 
	win = window_mode.get_item_text(index)
	
	## Set window mode
	Settings.settings_data["window_mode"] = win
	Settings.set_window_mode(win)
	
	## Save new settings
	Settings.write_settings()
	
	## Refresh resolution
	Settings.set_resolution(Settings.settings_data["resolution"])
	
	## In fullscreen disable resolution because it doesnt do a thing
	disable_resolution_selection()
	
	
	Logger.write_to_log(name, "window_mode option changed")
	Logger.write_to_console(name, "window_mode option changed")


## On resolution_value [OptionButton] selection, set the resolution and save selection into a file
func _on_resolution_value_item_selected(index):
	## Initialize variables
	var res 
	res = resolution.get_item_text(index)
	
	## Set resolution
	Settings.settings_data["resolution"] = res
	Settings.set_resolution(Settings.resolutions.get(res))
	
	## Save new settings
	Settings.write_settings()
	
	## Refresh window mode
	Settings.set_window_mode(Settings.settings_data["window_mode"])
	
	
	Logger.write_to_log(name, "vsync option changed")
	Logger.write_to_console(name, "vsync option changed")


## On vsync_value [OptionButton] selection, set the vsync and save selection into a file
func _on_vsync_value_item_selected(index):
	## Initialize variables
	var vnc 
	vnc = vsync.get_item_text(index)
	
	## Set resolution
	Settings.settings_data["vsync"] = vnc
	Settings.set_vsync(vnc)
	
	## Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "resolution option changed")
	Logger.write_to_console(name, "resolution option changed")


## On fps_value [TextEdit] selection, set the fps and save selection into a file
func _on_fps_value_text_submitted(new_text):
	new_text = int(new_text)
	if (
		new_text < 30 
		or new_text > 999
	):
		new_text = str(Settings.settings_data["fps"])
		fps.text = new_text
	
	## Set fps
	Settings.settings_data["fps"] = int(new_text)
	Settings.set_fps(int(new_text))
	
	## Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "fps value changed")
	Logger.write_to_console(name, "fps value changed")


## On brigtness_value [HSlider] selection, set the brightness and save selection into a file
func _on_brightness_value_value_changed(value):
	## Prevent darkness (0 made availabe because of design reason)
	if value == 0:
		value = 0.1
	
	## Set brightness
	Settings.settings_data["brightness"] = value
	Settings.set_brightness(value)
	
	## Set value to label
	brightness_label.text = str(Settings.settings_data["brightness"])
	
	## Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "brightness value changed")
	Logger.write_to_console(name, "brightness value changed")


## On sfx_value [HSlider] selection, set the sfx volume and save selection into a file
func _on_sfx_value_value_changed(value):
	## Set sfx
	Settings.settings_data["sfx"] = value
	Settings.set_sfx(value)
	
	## Set value to label
	sfx_label.text = str(Settings.settings_data["sfx"])
	
	## Save new settings
	Settings.write_settings()
	
	
	if (
		Global.debug 
		and self.name == "main_menu_settings"
	):
		var explosion 
		explosion = AudioStreamPlayer.new()
		explosion.stream = load("res://resources/sounds/explosion.ogg")
		explosion.bus = "SFX"
		add_child(explosion)
		
		explosion.play()
		await explosion.finished
		explosion.queue_free()
	
	
	Logger.write_to_log(name, "sfx value changed")
	Logger.write_to_console(name, "sfx value changed")


## On music_value [HSlider] selection, set the music volume and save selection into a file
func _on_music_value_value_changed(value):
	## Set sfx
	Settings.settings_data["music"] = value
	Settings.set_music(value)
	
	## Set value to label
	music_label.text = str(Settings.settings_data["music"])
	
	## Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "music value changed")
	Logger.write_to_console(name, "music value changed")


## On debug_value [OptionButton] selection set the [Global.debug] and save selection into a file
func _on_debug_value_item_selected(index):
	## Load debug value into variable
	var item_text 
	item_text = debug.get_item_text(index)
	
	## Check if value is on/off, on = true, off = false
	if item_text.to_lower() == "on":
		Settings.settings_data["debug"] = true
	else:
		Settings.settings_data["debug"] = false
	
	## Set debug
	Settings.set_debug(Settings.settings_data["debug"])
	
	## Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "debug option changed")
	Logger.write_to_console(name, "debug option changed")


## On logging_value [OptionButton] selection set the [Global.logging] and save selection into a file
func _on_logging_value_item_selected(index):
	## Load debug value into variable
	var item_text 
	item_text = logging.get_item_text(index)
	
	## Check if value is on/off, on = true, off = false
	if item_text.to_lower() == "on":
		Settings.settings_data["logging"] = true
	else:
		Settings.settings_data["logging"] = false
	
	## Set debug
	Settings.set_logging(Settings.settings_data["logging"])
	
	## Save new settings
	Settings.write_settings()
	
	
	Logger.write_to_log(name, "debug option changed")
	Logger.write_to_console(name, "debug option changed")


## Open keybinds [main_menu_keybinds.tsnc] on Keybinds [Button] press
func _on_keybinds_pressed():
	get_tree().change_scene_to_file(keybinds)
	
	
	Logger.write_to_log(name, "open keybinds")
	Logger.write_to_console(name, "open keybinds")


## Return to mainMenu [main_menu.tsnc] on BackToMainMenu [Button] press
func _on_back_pressed():
	get_tree().change_scene_to_file(main_menu)
	
	
	Logger.write_to_log(name, "open main_menu")
	Logger.write_to_console(name, "open main_menu")
