extends Node



const settings_data_default = {
	"window_mode" : "window",
	"resolution" : "1920 x 1080",
	"brightness" : 1.0,
	"debug" : false
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
	var read 
	read = FileAccess.open(file_path, FileAccess.READ)
	if read != null:
		# Load data from text into variable
		settings_data = read.get_as_text()
		
		# Convert JSON to Dictionary & close
		settings_data = str_to_var(settings_data)
		read.close() 
		
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
	write.store_line(storable_settings)
	write.close()
	
	
	Logger.write_to_log(name, "write settings")
	Logger.write_to_console(name, "write settings")


func load_settings():
	set_window_mode(settings_data["window_mode"])
	set_resolution(settings_data["resolution"])
	set_brightness(settings_data["brightness"])
	set_debug(settings_data["debug"])
	
	
	Logger.write_to_log(name, "load settings")
	Logger.write_to_console(name, "load settings")



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
	
	
	Logger.write_to_log(name, "resolution set")
	Logger.write_to_console(name, "resolution set")


# Set brightness
func set_brightness(value):
	# Set brightness of "brightness_control.tsnc"
	BrightnessControl.environment.adjustment_brightness = value
	
	
	Logger.write_to_log(name, "brightness set")
	Logger.write_to_console(name, "brightness set")


# Set debug
func set_debug(value):
	# Set global variable debug
	Global.debug = value
	
	
	Logger.write_to_log(name, "debug set")
	Logger.write_to_console(name, "debug set")
