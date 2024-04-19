extends Control



@export_category("Plane data limits")
@export var altitude_min : int = 0
@export var altitude_max : int = 35000
@export var heading_min : int = 0
@export var heading_max : int = 359
@export var speed_min : int = 120
@export var speed_max : int = 350

var callsign_label : Label
var altitude : LineEdit
var heading : LineEdit
var speed : LineEdit
var status_label : Label
var direct : OptionButton
var land : OptionButton
var hold : Button

var nav_points_list : Dictionary
var runways_list : Dictionary

var id_callsign
var planes
var nav_points
var runways
var update_repeat_s : int = 1
var i : int



# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS # The script will work even when the game is Frozen ("let it go..")
	
	callsign_label = $callsign
	altitude = $data/values/altitude_value
	heading = $data/values/heading_value
	speed = $data/values/speed_value
	status_label = $status/status
	direct = $data/values/direct_value
	land = $commands/land
	hold = $commands/hold
	
	planes = get_node("../../planes")
	nav_points = get_node("../../nav_points")
	runways = get_node("../../runways")
	load_nav_points()
	load_runways()
	
	direct.select(0)
	land.select(0)
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Get plane by callsign
func get_plane():
	var pl
	if planes != null:
		pl = planes.get_children()
		for p in pl:
			if p.name.contains(str(id_callsign)):
				return p


# Update plane data in sidebar bottom tab
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


# Set the point the plane is going towards 
func get_direct_point(value):
	for j in range(0, direct.item_count):
		if direct.get_item_text(j) == value:
			return j
	return 0


# Set the point the plane is going towards
func get_direct_runway(value):
	for j in range(0, land.item_count):
		if land.get_item_text(j) == value:
			return j
	return 0


# Set callsign to refer to a plane
func callsign_reference(value):
	id_callsign = value.text
	
	
	Logger.write_to_log(name, "callsign reference set")
	Logger.write_to_console(name, "callsign reference set")


# Load all nav_points into direct_to optionsbutton
func load_nav_points():
	var n_p
	if nav_points != null:
		n_p = nav_points.get_children()
		for n in n_p:
			nav_points_list[n.name.to_upper()] = n
			direct.add_item(n.name.to_upper())
	
	
	Logger.write_to_log(id_callsign, "nav_points_selection loaded")
	Logger.write_to_console(id_callsign, "nav_points_selection loaded")


# Load all runways just like direct points to the options menu
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
	
	
	Logger.write_to_log(id_callsign, "runways_selection loaded")
	Logger.write_to_console(id_callsign, "runways_selection loaded")


# Reset plane data on landing canceled
func cancel(plane):
	if plane.is_in_group("landing"):
		plane.cancel_landing()
		reset_selection()
		
		
		Logger.write_to_log(name, "cancel")
		Logger.write_to_console(name, "cancel")


func reset_selection():
	direct.select(0)
	land.select(0)
	
	
	Logger.write_to_log(name, "reset selection")
	Logger.write_to_console(name, "reset selection")


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
		
		
		Logger.write_to_log(id_callsign, "disabled input")
		Logger.write_to_console(id_callsign, "disabled input")


# Set altitude of plane on text change
func _on_altitude_value_text_submitted(new_text):
	new_text = int(new_text)
	
	if new_text < 0:
		new_text = new_text * -1
	elif new_text > altitude_max:
		new_text = altitude_max
	elif new_text < altitude_min:
		new_text = altitude_min
	
	altitude.text = str(new_text)
	
	var plane
	plane = get_plane()
	plane.set_altitude(new_text)
	
	Logger.write_to_log(id_callsign, "altitude set", new_text)
	Logger.write_to_console(id_callsign, "altitude set", new_text)


# Set heading of plane on text change
func _on_heading_value_text_submitted(new_text):
	new_text = int(new_text)
	
	if new_text < 0:
		new_text = new_text * -1
	if new_text > heading_max:
		new_text = heading_max
	if new_text < heading_min:
		new_text = heading_min
	
	heading.text = str(new_text)
	
	var plane
	plane = get_plane()
	plane.set_heading(new_text)
	plane.set_status("fly")
	
	hold.emit_signal("toggled", false)
	
	
	Logger.write_to_log(id_callsign, "heading set", new_text)
	Logger.write_to_console(id_callsign, "heading set", new_text)


# Set speed of plane on text change
func _on_speed_value_text_submitted(new_text):
	new_text = int(new_text)
	
	if new_text < 0:
		new_text = new_text * -1
	if new_text > speed_max:
		new_text = speed_max
	if new_text < speed_min:
		new_text = speed_min
	
	speed.text = str(new_text)
	
	var plane
	plane = get_plane()
	plane.set_speed(new_text)
	
	
	Logger.write_to_log(id_callsign, "speed set", new_text)
	Logger.write_to_console(id_callsign, "speed set", new_text)


# Direct to selected -> plane gets sent to it
func _on_direct_value_item_selected(index):
	var plane
	var point
	
	plane = get_plane()
	land.select(0)
	hold.emit_signal("toggled", false)
	
	if visible:
		if index != 0:
			point = nav_points_list[str(direct.get_item_text(index))]
			
			plane.set_point(point)
			plane.set_status("direct")
		elif (
			index == 0 
			and direct.has_focus()
		):
			plane.set_point(null)
			plane.set_status("fly")
			
			point = Node.new()
			point.name = "none"
	
	
	
	Logger.write_to_log(id_callsign, "fly towards nav_point selected", point.name)
	Logger.write_to_console(id_callsign, "fly towards nav_point selected", point.name)


# Runway selected -> plane gets sent to it
func _on_land_item_selected(index):
	var plane
	var point
	
	plane = get_plane()
	direct.select(0)
	hold.emit_signal("toggled", false)
	
	if visible:
		if index != 0:
			point = runways_list[str(land.get_item_text(index))]
			
			plane.set_point(point)
			plane.set_status("direct")
			plane.add_to_group("land")
		elif (
			index == 0
			and land.has_focus()
		):
			plane.set_point(null)
			plane.set_status("fly")
			
			point = Node.new()
			point.name = "none"
	
	
	Logger.write_to_log(id_callsign, "land on runway selected", point.name)
	Logger.write_to_console(id_callsign, "land on runway selected", point.name)


func _on_hold_toggled(toggled_on):
	var plane
	plane = get_plane()
	
	if visible:
		if toggled_on:
			plane.hold()
			plane.hold_timer.start()
			plane.set_point(null)
		else:
			plane.set_heading(plane.heading)
			plane.set_status("fly")
			plane.hold_timer.stop()
	
	
	Logger.write_to_log(id_callsign, "hold toggled", toggled_on)
	Logger.write_to_console(id_callsign, "hold toggled", toggled_on)


# Update data when description tab is shown
func _on_draw():
	update_data()
	disable_input()


# Update data every x seconds
func _on_data_timer_timeout():
	update_data()


# Hide window on "close" press
func _on_close_button_pressed():
	visible = false
