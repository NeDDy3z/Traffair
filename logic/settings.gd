extends Node



const window_modes = [
	"Fullscreen",
	"Fullscreen-Bordless",
	"Window",
	"Window-Bordless"
]
const resolutions = {
	"3840 x 2160" : Vector2i(3840,2160),
	"2880 x 1800" : Vector2i(2880,1800),
	"2560 x 1440" : Vector2i(2560,1440),
	"1920 x 1200" : Vector2i(1920,1200),
	"1920 x 1080" : Vector2i(1920,1080),
	"1680 x 1050" : Vector2i(1680,1050),
	"1600 x 900" : Vector2i(1600,900)
}
const vsyncs = [
	"On",
	"Off",
	"Adaptive"
]

const required_settings_keys = [
	"window_mode",
	"resolution",
	"vsync",
	"fps",
	"brightness",
	"sfx",
	"music",
	"debug",
	"logging"
]
const settings_data_default = {
	"window_mode" : "window",
	"resolution" : "1920 x 1080",
	"vsync" : "on",
	"fps" : 60,
	"brightness" : 1.0,
	"sfx" : 50,
	"music" : 50,
	"debug" : false,
	"logging" : true
}
var settings_data

var file_path : String
var dir_access 
var read
var write



# Load settings on startup
# Called when the node enters the scene tree for the first time.
func _ready():
	# Set file_path of settings file
	file_path = "user://settings/settings.conf"
	
	# Create settings folder
	create_settings()
	
	# Load saved settings into values
	read_settings()
	load_settings()
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Create "settings" folder if it doesnt exist
func create_settings():
	dir_access = DirAccess.open("user://")
	if not dir_access.dir_exists("settings"):
		dir_access.make_dir("settings")
	# Create settings file if it doesnt exist (it definitely doesnt)
	if not FileAccess.file_exists("user://settings/settings.conf"):
		write_settings(settings_data_default)
	
	
	Logger.write_to_log(name, "created settings folder and file")
	Logger.write_to_console(name, "created settings folder and file")


# Load settings from file
func read_settings():
	# Open file in read mode
	read = FileAccess.open(file_path, FileAccess.READ)
	if read != null:
		# Load data from text into variable
		settings_data = read.get_as_text()
		read.close() 
		
		# Convert JSON to Dictionary & close
		settings_data = str_to_var(settings_data)
		
		validate_dic(settings_data)
		
		# Prevent zero value
		if settings_data["brightness"] == 0:
			settings_data["brightness"] = 0.1
		
		Logger.write_to_log(name, "read settings")
		Logger.write_to_console(name, "read settings")
	else:
		create_settings()

		Logger.write_to_log(name, "failed to read settings", "settings file does not exist")
		Logger.write_to_console(name, "failed to read settings", "settings file does not exist")


# Save settings to file 
# [ value : Dictionary = settings_data ] => is an "optional argument"
func write_settings(value : Dictionary = settings_data):
	# Convert dictionary with settings into savable fromat
	var storable_settings = JSON.stringify(value, "\t", false)
	
	# Open file in write mode and save settings data
	write = FileAccess.open(file_path, FileAccess.WRITE)
	write.store_line(storable_settings.to_lower())
	write.close()
	
	
	Logger.write_to_log(name, "write settings")
	Logger.write_to_console(name, "write settings")


func load_settings():
	set_window_mode(settings_data["window_mode"])
	set_resolution(settings_data["resolution"])
	set_vsync(settings_data["vsync"])
	set_fps(settings_data["fps"])
	set_brightness(settings_data["brightness"])
	set_debug(settings_data["debug"])
	set_logging(settings_data["logging"])
	
	
	Logger.write_to_log(name, "load settings")
	Logger.write_to_console(name, "load settings")


# Validate if dictionary contains all required keys and corresponding data
func validate_dic(value : Dictionary):
	var valid = true
	for key in required_settings_keys:
		if key not in value:
			valid = false
	
	if valid:
		Logger.write_to_log(name, "settings valid", valid)
		Logger.write_to_console(name, "settings valid", valid)
	else:
		write_settings(settings_data_default)
		read_settings()
		
		Logger.write_to_log(name, "settings valid", valid)
		Logger.write_to_console(name, "settings valid", valid)
		Logger.write_to_log(name, "settings reset")
		Logger.write_to_console(name, "settings reset")


# Set fullscreen
func set_window_mode(value):
	match value.to_lower():
		"fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		"fullscreen-bordless":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		"window":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		"window-bordless":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	
	
	Logger.write_to_log(name, "window_mode set", value)
	Logger.write_to_console(name, "window_mode set", value)


# Set resolution
func set_resolution(value):
	if value is Vector2i:
		DisplayServer.window_set_size(value)
	elif value:
		var x 
		var y
		x = int(value.split(" x ")[0])
		y = int(value.split(" x ")[1])
		DisplayServer.window_set_size(Vector2i(x,y))
		
	
	Logger.write_to_log(name, "resolution set", value)
	Logger.write_to_console(name, "resolution set", value)


# Set vsync
func set_vsync(value):
	match value.to_lower():
		"on":
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		"off":
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		"adaptive":
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	
	
	Logger.write_to_log(name, "vsync set", value)
	Logger.write_to_console(name, "vsync set", value)


# Set fps
func set_fps(value):
	Engine.max_fps = value
	
	
	Logger.write_to_log(name, "fps set", value)
	Logger.write_to_console(name, "fps set", value)


# Set brightness
func set_brightness(value):
	# Prevent zero value
	if value == 0:
		value = 0.1
	
	# Set brightness of "brightness_control.tsnc"
	BrightnessControl.environment.adjustment_brightness = value
	
	
	Logger.write_to_log(name, "brightness set", value)
	Logger.write_to_console(name, "brightness set", value)


# Set sound level
func set_sfx(value):
	var sfx 
	var db
	
	sfx = AudioServer.get_bus_index("SFX")
	db = linear_to_db(value) # Convert <0-100> to <-80,-0>
	
	AudioServer.set_bus_volume_db(sfx, db)
	
	
	Logger.write_to_log(name, "sfx volume set", value)
	Logger.write_to_console(name, "sfx volume set", value)


# Set music level
func set_music(value):
	var music
	var db
	
	music = AudioServer.get_bus_index("Music")
	db = linear_to_db(value) # Convert <0-100> to <-80,-0>
	
	AudioServer.set_bus_volume_db(music, db)
	
	
	Logger.write_to_log(name, "music volume set", value)
	Logger.write_to_console(name, "music volume set", value)


# Set debug
func set_debug(value):
	# Set global variable debug
	Global.debug = value
	
	
	Logger.write_to_log(name, "debug set", value)
	Logger.write_to_console(name, "debug set", value)


# Set logging
func set_logging(value):
	Logger.write_to_log(name, "logging set", value)
	Logger.write_to_console(name, "logging set", value)
	
	
	Global.logging = value
	# Formatting reversed because the logger will stop working after setting it to false


# Get window size
func get_resolution():
	var res
	var x
	var y
	
	res = settings_data["resolution"]
	x = res[0]
	y = res[1]
	
	Logger.write_to_log(name, "resolution get", x+","+y)
	Logger.write_to_console(name, "resolution get", x+","+y)
	
	return Vector2(x,y)
