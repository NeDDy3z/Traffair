extends Node



var file_path : String
var log_read
var log_write

var dir_access 
var temp_data : String = ""



# Called when the node enters the scene tree for the first time.
func _ready():
	## Create my_logs folder if nonexistant
	dir_access = DirAccess.open("user://")
	if !dir_access.dir_exists("my_logs"):
		dir_access.make_dir("my_logs")
	
	## Set log file path & name
	var datetime 
	datetime = Time.get_datetime_dict_from_system()
	file_path = "user://my_logs/log_"+ str("%02d-%02d-%02d_%02d.%02d" % [datetime.year, datetime.month, datetime.day, datetime.hour, datetime.minute]) +".log"

	
	write_to_log("Game", "new game started", "----------------------------------- ]]]")
	write_to_console("Game", "new game started", "----------------------------------- ]]]")
	write_to_log("Logger", "loaded")
	write_to_console("Logger", "loaded")


## Write into log file
func write_to_log(object, action = "", message = ""):
	if (
		Global.logging 
		and !(Global.log_antispam and action == "direct_to()")
		and !(Global.log_antispam and action == "get_plane_data()")
	):
		var time
		time = Time.get_time_string_from_system()
		
		object = str(object)
		action = str(action)
		message = str(message)
		
		## Convert data into a easily readable string
		var out : String 
		out = ""
		if object == "":
			out += " [ object_??"
		else:
			out += " [ "+ object
		
		if action == "":
			out += " ] "
		else:
			out += " - "+ action +" ] " 
		
		if message == "":
			out += ""
		else:
			out += " : "+ message
		
		## Open the file
		## Read already written data and store them into the temporary variable
		## Write old data with new new data appended into the file
		## Close file
		log_read = FileAccess.open(file_path, FileAccess.READ)
		if log_read != null:
			temp_data = log_read.get_as_text()
			
		log_write = FileAccess.open(file_path, FileAccess.WRITE_READ)
		log_write.store_line(temp_data + str(time) +" "+ str(out))
		log_write.close()


## Write into console log (which is also saved by the godot itself)
func write_to_console(object, action = "", message = ""):
	if (
		Global.logging 
		and !(Global.log_antispam and action == "direct_to()")
		and !(Global.log_antispam and action == "get_plane_data()")
	):
		var time
		time = Time.get_time_string_from_system()
		
		object = str(object)
		action = str(action)
		message = str(message)
		
		var out
		out = time 
		
		## Convert data into a easily readable string
		if object == "":
			out += " [ object_??"
		else:
			out += " [ "+ object
		
		if action == "":
			out += " ] "
		else:
			out += " - "+ action +" ] " 
			
		if message == "":
			out += ""
		else:
			out += " : "+ message
		
		## Print data into a Debug console
		print(out)
