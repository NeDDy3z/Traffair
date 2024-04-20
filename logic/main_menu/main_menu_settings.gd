extends Control



@onready var resolution = $options_container/HBoxContainer/VBoxContainer2/resolution_value
@onready var window_mode = $options_container/HBoxContainer/VBoxContainer2/window_mode
@onready var vsync = $options_container/HBoxContainer/VBoxContainer2/vsync_value
@onready var fps = $options_container/HBoxContainer/VBoxContainer2/fps_value
@onready var brightness = $options_container/HBoxContainer/VBoxContainer2/brightness_box/brightness_value
@onready var brightness_label = $options_container/HBoxContainer/VBoxContainer2/brightness_box/brightness_value/brightness_value_label
@onready var sfx = $options_container/HBoxContainer/VBoxContainer2/sfx_box/sfx_value
@onready var sfx_label = $options_container/HBoxContainer/VBoxContainer2/sfx_box/sfx_value/sfx_value_label
@onready var music = $options_container/HBoxContainer/VBoxContainer2/music_box/music_value
@onready var music_label = $options_container/HBoxContainer/VBoxContainer2/music_box/music_value/music_value_label
@onready var debug = $options_container/HBoxContainer/VBoxContainer2/debug_value



## Called when the node enters the scene tree for the first time.
func _ready():
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
	
	
	## Call [code]disable_resolution_selection[/code]
	disable_resolution_selection()


## Disable resolution_value [OptionButton] if the game is in Fullscreen mode
func disable_resolution_selection():
	var wm_text = window_mode.get_item_text(window_mode.get_selected_id())
	
	if wm_text == Settings.window_modes[0] or wm_text == Settings.window_modes[1]:
		var screen_size = DisplayServer.screen_get_size()
		resolution.disabled = true
		
		for i in resolution.item_count:
			if resolution.get_item_text(i).to_lower() == str(screen_size.x) +" x "+ str(screen_size.y):
				resolution.select(i)
	else:
		resolution.disabled = false
		resolution.emit_signal("item_selected", resolution.get_selected_id())



## On window_mode_value [OptionButton] selection, set the window_mode and save selection into a file
func _on_window_mode_item_selected(index):
	## Initialize variables
	var win = window_mode.get_item_text(index)
	
	## Set window mode
	Settings.settings_data["window_mode"] = win
	Settings.set_window_mode(win)
	
	## Save new settings
	Settings.write_settings()
	
	## Refresh resolution
	Settings.set_resolution(Settings.settings_data["resolution"])
	
	## In fullscreen disable resolution because it doesnt do a thing
	disable_resolution_selection()


## On resolution_value [OptionButton] selection, set the resolution and save selection into a file
func _on_resolution_value_item_selected(index):
	## Initialize variables
	var res = resolution.get_item_text(index)
	
	## Set resolution
	Settings.settings_data["resolution"] = res
	Settings.set_resolution(Settings.resolutions.get(res))
	
	## Save new settings
	Settings.write_settings()
	
	## Refresh window mode
	Settings.set_window_mode(Settings.settings_data["window_mode"])


## On vsync_value [OptionButton] selection, set the vsync and save selection into a file
func _on_vsync_value_item_selected(index):
	## Initialize variables
	var vnc = vsync.get_item_text(index)
	
	## Set resolution
	Settings.settings_data["vsync"] = vnc
	Settings.set_vsync(vnc)
	
	## Save new settings
	Settings.write_settings()


## On fps_value [TextEdit] selection, set the fps and save selection into a file
func _on_fps_value_text_submitted(new_text):
	new_text = int(new_text)
	if new_text < 30 or new_text > 999:
		new_text = str(Settings.settings_data["fps"])
		fps.text = new_text
	
	## Set fps
	Settings.settings_data["fps"] = int(new_text)
	Settings.set_fps(int(new_text))
	
	## Save new settings
	Settings.write_settings()


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


## On sfx_value [HSlider] selection, set the sfx volume and save selection into a file
func _on_sfx_value_value_changed(value):
	## Set sfx
	Settings.settings_data["sfx"] = value
	Settings.set_sfx(value)
	
	## Set value to label
	sfx_label.text = str(Settings.settings_data["sfx"])
	
	## Save new settings
	Settings.write_settings()
	
	
	if Global.debug and self.name == "main_menu_settings":
		var explosion = AudioStreamPlayer.new()
		explosion.stream = load("res://resources/sounds/explosion.ogg")
		explosion.bus = "SFX"
		add_child(explosion)
		
		explosion.play()
		await explosion.finished
		explosion.queue_free()


## On music_value [HSlider] selection, set the music volume and save selection into a file
func _on_music_value_value_changed(value):
	## Set sfx
	Settings.settings_data["music"] = value
	Settings.set_music(value)
	
	## Set value to label
	music_label.text = str(Settings.settings_data["music"])
	
	## Save new settings
	Settings.write_settings()


## On debug_value [OptionButton] selection set the [Global.debug] and save selection into a file
func _on_debug_value_item_selected(index):
	## Load debug value into variable
	var item_text = debug.get_item_text(index)
	
	## Check if value is on/off, on = true, off = false
	if item_text.to_lower() == "on":
		Settings.settings_data["debug"] = true
	else:
		Settings.settings_data["debug"] = false
	
	## Set debug
	Settings.set_debug(Settings.settings_data["debug"])
	
	## Save new settings
	Settings.write_settings()


## Open keybinds [main_menu_keybinds.tsnc] on Keybinds [Button] press
func _on_keybinds_pressed():
	get_tree().change_scene_to_file(Global.main_menu_paths["keybinds"])


## Return to mainMenu [main_menu.tsnc] on BackToMainMenu [Button] press
func _on_back_pressed():
	get_tree().change_scene_to_file(Global.main_menu_paths["main_menu"])
