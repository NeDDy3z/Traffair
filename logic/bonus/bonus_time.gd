extends Button



var text_label : Label
var time : String



# Called when the node enters the scene tree for the first time.
func _ready():
	text_label = $"../../../../text"
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Set text of the label
func set_text_label(value):
	var out
	if (
		value != null
	):
		out = "Time:\n"
		out += value
	
	text_label.text = out
	
	
	Logger.write_to_log(name, "set_text_label()", out)
	Logger.write_to_console(name, "set_text_label()", out)


# On button click, show time
func _on_pressed():
	time = Time.get_time_string_from_system()
	set_text_label(time)
	
	
	Logger.write_to_log(name, "show time", text_label.text)
	Logger.write_to_console(name, "show time", text_label.text)
