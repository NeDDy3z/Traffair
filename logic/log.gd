extends Node



static var log_file : String



static func write_to_log(object, action, message):
	var date = Time.get_time_string_from_system()
	
	object = str(object)
	action = str(action)
	message = str(message)
	
	var data = [ object, action, message ]
	
	if log_file == null:
		log_file = "res://test.dat"
		FileAccess.open(log_file, FileAccess.WRITE).store_string("tr")


static func write_to_console(object, action, message):
	var date = Time.get_time_string_from_system()
	
	object = str(object)
	action = str(action)
	message = str(message)
	
	var out = date 
	
	# Its like this bcs of the project requirements
	if object == "":
		out += " [ object_?"
	elif object == "-":
		out += " [ "
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
