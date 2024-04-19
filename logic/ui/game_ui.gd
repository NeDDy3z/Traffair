extends Control




var description : Object
var controls : Object
var queue : Object
var game_time : Timer
var counter : Label
var timer : Label

var plane_tab_prefab : Object



func _ready():
	description = $description
	controls = $controls
	queue = $timetable/queue_scrollcontainer/queue_vboxcontainer
	game_time = $game_time
	counter = $counter/counter
	timer = $counter/timer
	plane_tab_prefab = load("res://prefabs/plane_tab.tscn")
	
	game_time.start()
	
	if Global.debug:
		description.visible = true
	else:
		description.visible = false
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


func add_plane_tab(value):
	var plane_values
	var plane_tab 
	var plane_tab_items 
	
	plane_values = value.get_plane_data()
	plane_tab = plane_tab_prefab.instantiate()
	plane_tab.name = "plane_tab"+str(plane_values["callsign"])
	plane_tab_items = {
		"callsign" : plane_tab.get_node("Button/callsign"),
		"altitude" : plane_tab.get_node("Button/data_hboxcontainer/values_vboxcontainer/altitude_value"),
		"heading" : plane_tab.get_node("Button/data_hboxcontainer/values_vboxcontainer/heading_value"),
		"speed" : plane_tab.get_node("Button/data_hboxcontainer/values_vboxcontainer/speed_value")
	}
	
	# Set data of plane to tab
	plane_tab_items["callsign"].text = str(plane_values["callsign"])
	plane_tab_items["altitude"].text = str(plane_values["altitude"])
	plane_tab_items["heading"].text = str(int(plane_values["heading"]))
	plane_tab_items["speed"].text = str(plane_values["speed"])
	
	# Add tab
	queue.add_child(plane_tab, true)
	
	
	Logger.write_to_log("plane_tab"+plane_values["callsign"], "added")
	Logger.write_to_console("plane_tab"+plane_values["callsign"], "added")


func counter_add(value : int = 1):
	counter.text = "✈️" + str(int(counter.text) + value)
	
	
	Logger.write_to_log("counter", "added 1 point")
	Logger.write_to_console("counter", "added 1 point")


func counter_deduct(value : int = -1):
	counter.text = "✈️" + str(int(counter.text) + value)
	
	
	Logger.write_to_log("counter", "deducted 1 point")
	Logger.write_to_console("counter", "deducted 1 point")


# Add one second to the timer
func time_add_second():
	var time : Array
	time = timer.text.split(":")
	
	# Convert to int array
	time = time as PackedInt64Array
	
	# Timing... adding seconds, minutes...
	time[2] += 1
	if time[2] >= 60:
		time[1] += 1
		time[2] = 0
	if time[1] >= 60:
		time[0] +=  1
		time[1] = 0
	
	# Convert to string array
	time = time as PackedStringArray
	
	# If the lenght of the string is only 1 digit add zero before it
	for i in range(0, time.size()):
		if time[i].length() == 1:
			time[i] = "0"+ time[i]
	
	# Set label text
	timer.text = time[0] +":"+ time[1] +":"+ time[2]


# Executed every x seconds the timer Node is set to
func _on_elapsed_time_timeout():
	time_add_second()
