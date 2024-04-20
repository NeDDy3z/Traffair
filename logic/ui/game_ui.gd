extends Control




@onready var description = $description
@onready var controls = $controls
@onready var queue = $timetable/queue_scrollcontainer/queue_vboxcontainer
@onready var game_time = $game_time
@onready var counter = $counter/counter
@onready var timer = $counter/timer

var plane_tab_prefab = preload("res://prefabs/plane_tab.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	## Start the game_time [Timer]
	game_time.start()
	
	## Set visibility of the [game_ui.description] Node based on [Global.debug] 
	if Global.debug:
		description.visible = true
	else:
		description.visible = false


## Add [plane_tab.tsnc] prefab to the plane tab list [timetable/queue_scroll/container.queue_vboxcontainer]
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
	
	## Set data of the plane_tab [Node]
	plane_tab_items["callsign"].text = str(plane_values["callsign"])
	plane_tab_items["altitude"].text = str(plane_values["altitude"])
	plane_tab_items["heading"].text = str(int(plane_values["heading"]))
	plane_tab_items["speed"].text = str(plane_values["speed"])
	
	## Add plane_tab [Node]
	queue.add_child(plane_tab, true)


## Add one point to the [counter]
func counter_add(value : int = 1):
	counter.text = "✈️" + str(int(counter.text) + value)


## Deduct one point from the [counter]
func counter_deduct(value : int = -1):
	counter.text = "✈️" + str(int(counter.text) + value)


## Update gmae_time [Label]
## Ensuring a good looking timer
func time_add_second():
	var time = timer.text.split(":")
	
	## Convert to IntArray
	time = time as PackedInt64Array
	
	## Clock
	time[2] += 1
	if time[2] >= 60:
		time[1] += 1
		time[2] = 0
	if time[1] >= 60:
		time[0] +=  1
		time[1] = 0
	
	## Convert to StringArry
	time = time as PackedStringArray
	
	## Add zero before the digit if its only 1 character long
	for i in range(0, time.size()):
		if time[i].length() == 1:
			time[i] = "0"+ time[i]
	
	## Set value of the [Label]
	timer.text = time[0] +":"+ time[1] +":"+ time[2]


## Elapsed time [Timer], once every [Timer.timeout] second(s) a [code]time_add_second[/code] is called
func _on_elapsed_time_timeout():
	time_add_second()
