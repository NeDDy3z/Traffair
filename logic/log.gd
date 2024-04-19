extends Node



var file_path : String
var log_read
var log_write

var dir_access 
var temp_data : String = ""



# Called when the node enters the scene tree for the first time.
func _ready():
	# Make "my_logs" folder if it doesnt exist
	dir_access = DirAccess.open("user://")
	if !dir_access.dir_exists("my_logs"):
		dir_access.make_dir("my_logs")
	
	var datetime 
	datetime = Time.get_datetime_dict_from_system()
	file_path = "user://my_logs/log_"+ str("%02d-%02d-%02d_%02d.%02d" % [datetime.year, datetime.month, datetime.day, datetime.hour, datetime.minute]) +".log"

	
	write_to_log("Game", "new game started", "----------------------------------- ]]]")
	write_to_console("Game", "new game started", "----------------------------------- ]]]")
	write_to_log("Logger", "loaded")
	write_to_console("Logger", "loaded")


# Write into file log
func write_to_log(object, action = "", message = ""):
	if (Global.logging 
			and !(Global.log_antispam 
					and action == "direct_to()")):
		var time
		time = Time.get_time_string_from_system()
		
		object = str(object)
		action = str(action)
		message = str(message)
		
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
		
		# Open file - store data into variable - write old data + new data into file
		log_read = FileAccess.open(file_path, FileAccess.READ)
		if log_read != null:
			temp_data = log_read.get_as_text()
			
		log_write = FileAccess.open(file_path, FileAccess.WRITE_READ)
		log_write.store_line(temp_data + str(time) +" "+ str(out))
		log_write.close()


# Write into console log
func write_to_console(object, action = "", message = ""):
	if (Global.logging 
			and !(Global.log_antispam 
					and action == "direct_to()")):
		var time
		time = Time.get_time_string_from_system()
		
		object = str(object)
		action = str(action)
		message = str(message)
		
		var out
		out = time 
		
		# Its like this bcs of the project requirements
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
		
		print(out)
