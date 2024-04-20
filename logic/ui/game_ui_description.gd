extends Control



## Maximum and minimum values a [Plane] can have
@export_category("Plane data limits")
@export var altitude_min : int = 0
@export var altitude_max : int = 35000
@export var heading_min : int = 0
@export var heading_max : int = 359
@export var speed_min : int = 120
@export var speed_max : int = 350

var nav_points_list : Dictionary
var runways_list : Dictionary
var id_callsign

@onready var callsign_label = $callsign
@onready var altitude = $data/values/altitude_value
@onready var heading = $data/values/heading_value
@onready var speed = $data/values/speed_value
@onready var status_label = $status/status
@onready var direct = $data/values/direct_value
@onready var land = $commands/land
@onready var hold = $commands/hold
@onready var planes = get_node("../../planes")
@onready var nav_points = get_node("../../nav_points")
@onready var runways = get_node("../../runways")



# Called when the node enters the scene tree for the first time.
func _ready():
	## [PROCESS_MODE_ALWAYS] ensures the script will still work when the game is frozen
	process_mode = Node.PROCESS_MODE_ALWAYS

	load_nav_points()
	load_runways()
	
	## Reset the [OptionButton]s selection 
	direct.select(0)
	land.select(0)


## Retrieve [Plane] by its callsign
func get_plane():
	var pl
	if planes != null:
		pl = planes.get_children()
		for p in pl:
			if p.name.contains(str(id_callsign)):
				return p


## Update [Plane] data 
func update_data():
	var data
	data = get_plane()
	if data != null:
		data = data.get_plane_data()
		callsign_label.text = str(data["callsign"])
		status_label.text = str(data["status"])
		
		if not altitude.has_focus():
			altitude.text = str(data["altitude"])
		if not heading.has_focus():
			heading.text = str(data["heading"])
		if not speed.has_focus():
			speed.text = str(data["speed"])
		direct.select(get_direct_point(str(data["direct"])))
		land.select(get_direct_runway(str(data["direct"])))


## Get a index value from the [OptionButton] list based on direct_point name
func get_direct_point(value):
	for j in range(0, direct.item_count):
		if direct.get_item_text(j) == value:
			return j
	return 0


## Get a index value from the [OptionButton] list based on runway_point name
func get_direct_runway(value):
	for j in range(0, land.item_count):
		if land.get_item_text(j) == value:
			return j
	return 0


## Set a reference callsign
func callsign_reference(value):
	id_callsign = value.text


## Load all direct_points to the Direct [OptionButton]
func load_nav_points():
	var n_p
	if nav_points != null:
		n_p = nav_points.get_children()
		for n in n_p:
			nav_points_list[n.name.to_upper()] = n
			direct.add_item(n.name.to_upper())


## Load all runway_points to the Land [OptionButton]
func load_runways():
	var rwys
	if runways != null:
		rwys = runways.get_children()
		for rws in rwys:
			var rw
			rw = rws.get_children()
			for r in rw:
				if r.name.contains("rw"):
					runways_list[r.name.to_upper()] = r
					land.add_item(r.name.to_upper())


## Reset [Plane] direction on landing canceled
func cancel(plane):
	if plane.is_in_group("landing"):
		plane.cancel_landing()
		direct.select(0)
		land.select(0)


## Turn off [game_ui_description] input when [Plane] initiates landing
func disable_input(plane : Object = null):
	if plane == null:
		plane = get_plane()
	
	if plane.status == plane.states["landing"]:
		altitude.editable = false
		heading.editable = false
		speed.editable = false
		direct.disabled = true
		land.disabled = true
		hold.disabled = true


## Set altitude of a [Plane] on [altitude.value] text submit
func _on_altitude_value_text_submitted(new_text):
	new_text = int(new_text)
	
	if new_text < 0:
		new_text = new_text * -1
	elif new_text > altitude_max:
		new_text = altitude_max
	elif new_text < altitude_min:
		new_text = altitude_min
	
	altitude.text = str(new_text)
	
	var plane = get_plane()
	plane.set_altitude(new_text)


## Set heading of a [Plane] on [heading.value] text submit
func _on_heading_value_text_submitted(new_text):
	new_text = int(new_text)
	
	if new_text < 0:
		new_text = new_text * -1
	if new_text > heading_max:
		new_text = heading_max
	if new_text < heading_min:
		new_text = heading_min
	
	heading.text = str(new_text)
	
	var plane = get_plane()
	plane.set_heading(new_text)
	plane.set_status("fly")
	
	## Turn off hold pattern & reset Land & Direct [OptionButton] selection
	hold.emit_signal("toggled", false)
	land.select(0)
	direct.select(0)


## Set speed of a [Plane] on [speed.value] text submit
func _on_speed_value_text_submitted(new_text):
	new_text = int(new_text)
	
	if new_text < 0:
		new_text = new_text * -1
	if new_text > speed_max:
		new_text = speed_max
	if new_text < speed_min:
		new_text = speed_min
	
	speed.text = str(new_text)
	
	var plane = get_plane()
	plane.set_speed(new_text)


## Set point of a [Plane] on Direct [OptionButton] selection
## Reset selection in a Land [OptionButton]
func _on_direct_value_item_selected(index):
	var plane = get_plane()
	var point
	
	land.select(0)
	hold.emit_signal("toggled", false)
	
	if visible:
		if index != 0:
			point = nav_points_list[str(direct.get_item_text(index))]
			
			plane.set_point(point)
			plane.set_status("direct")
		elif index == 0 and direct.has_focus():
			plane.set_point(null)
			plane.set_status("fly")
			
			point = Node.new()
			point.name = "none"


## Set point of a [Plane] on Land [OptionButton] selection
## Reset selection in a Direct [OptionButton]
func _on_land_item_selected(index):
	var plane = get_plane()
	var point
	
	direct.select(0)
	hold.emit_signal("toggled", false)
	
	if visible:
		if index != 0:
			point = runways_list[str(land.get_item_text(index))]
			
			plane.set_point(point)
			plane.set_status("direct")
			plane.add_to_group("land")
		elif index == 0 and land.has_focus():
			plane.set_point(null)
			plane.set_status("fly")
			
			point = Node.new()
			point.name = "none"


## Set [Plane] to holding pattern on Hold [Button] toggle
func _on_hold_toggled(toggled_on):
	var plane = get_plane()
	
	if visible:
		if toggled_on:
			plane.hold()
			plane.hold_timer.start()
			plane.set_point(null)
		else:
			plane.set_heading(plane.heading)
			plane.set_status("fly")
			plane.hold_timer.stop()


## Update data on description open
func _on_draw():
	update_data()
	disable_input()


## Data [Timer], once every [Timer.timeout] seconds, call data update
func _on_data_timer_timeout():
	update_data()


## Hide description on close button
func _on_close_button_pressed():
	visible = false
