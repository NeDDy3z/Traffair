extends Button



var time : String
var text_label : Label



# Called when the node enters the scene tree for the first time.
func _ready():
	## Initialize variables
	text_label = $"../../../../text"
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


## Set [value] to the [text_label.text]
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


## On [Button] press call [code]set_text_label[/code] with [param time]
func _on_pressed():
	time = Time.get_time_string_from_system()
	set_text_label(time)
	
	
	Logger.write_to_log(name, "show time", text_label.text)
	Logger.write_to_console(name, "show time", text_label.text)
