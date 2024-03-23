extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


static func write_to_log(object, action, message):
	var date = Time.get_time_string_from_system()
	
	object = str(object)
	action = str(action)
	message = str(message)


static func write_to_console(object, action, message):
	var date = Time.get_time_string_from_system()
	
	object = str(object)
	action = str(action)
	message = str(message)
	
	var out = date 
	
	# Its like this bcs of the project requirements
	if object == "":
		out += " [ object_?"
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
