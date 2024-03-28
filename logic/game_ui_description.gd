extends Control



@export_category("Plane data limits")
@export var altitude_min : int = 0
@export var altitude_max : int = 35000
@export var heading_min : int = 0
@export var heading_max : int = 359
@export var speed_min : int = 120
@export var speed_max : int = 350

var callsign_label : Object
var altitude_textedit : Object
var heading_textedit : Object
var speed_textedit : Object
var status_label : Object
var direct_to_options : Object
var land_options : Object

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
	callsign_label = $callsign
	altitude_textedit = $data/values/altitude_value
	heading_textedit = $data/values/heading_value
	speed_textedit = $data/values/speed_value
	status_label = $status/status
	direct_to_options = $data/values/direct_value
	land_options = $commands/land
	
	planes = get_node("../../planes")
	nav_points = get_node("../../nav_points")
	runways = get_node("../../runways")
	load_nav_points()
	load_runways()
	
	direct_to_options.select(0)
	land_options.select(0)
	
	Logger.write_to_log("game_ui_description", "loaded")
	Logger.write_to_console("game_ui_description", "loaded")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Every 2 seconds update data
	i += 1
	if i == int(DisplayServer.screen_get_refresh_rate()) * update_repeat_s:
		i = 0
		update_data()


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
		
		if !altitude_textedit.has_focus():
			altitude_textedit.text = str(data["altitude"])
		if !heading_textedit.has_focus():
			heading_textedit.text = str(data["heading"])
		if !speed_textedit.has_focus():
			speed_textedit.text = str(data["speed"])
		if !direct_to_options.has_focus():
			direct_to_options.select(get_direct_point(str(data["direct"])))
		if !land_options.has_focus():
			land_options.select(get_direct_runway(str(data["direct"])))

# Set the point the plane is going towards 
func get_direct_point(value):
	for j in range(0, direct_to_options.item_count):
		if direct_to_options.get_item_text(j) == value:
			return j
	return 0


# Set the point the plane is going towards
func get_direct_runway(value):
	for j in range(0, land_options.item_count):
		if land_options.get_item_text(j) == value:
			return j
	return 0


# Set callsign to refer to a plane
func callsign_reference(value):
	id_callsign = value.text


# Load all nav_points into direct_to optionsbutton
func load_nav_points():
	var n_p
	if nav_points != null:
		n_p = nav_points.get_children()
		for n in n_p:
			nav_points_list[n.name.to_upper()] = n
			direct_to_options.add_item(n.name.to_upper())
	
	Logger.write_to_log("nav_points_selection", "loaded")
	Logger.write_to_console("nav_points_selection", "loaded")


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
					land_options.add_item(r.name.to_upper())
	
	Logger.write_to_log("runways_selection", "loaded")
	Logger.write_to_console("runways_selection", "loaded")


# Reset plane data on landing canceled
func cancel_landing(plane):
	if plane.is_in_group("landing"):
		plane.cancel_landing()
		plane.set_altitude(8000)
		plane.set_speed(250)


# Update data when description tab is shown
func _on_draw():
	update_data()


# Hide window on "close" press
func _on_close_button_pressed():
	visible = false


# Set altitude of plane on text change
func _on_altitude_value_text_submitted(new_text):
	new_text = int(new_text)
	
	if new_text > altitude_max:
		new_text = altitude_max
	if new_text < altitude_min:
		new_text = altitude_min
	
	altitude_textedit.text = str(new_text)
	
	var plane
	plane = get_plane()
	plane.set_altitude(new_text)
	
	# Reset plane data on landing canceled
	cancel_landing(plane)
	
	Logger.write_to_log("altitude", "set", new_text)
	Logger.write_to_console("altitude", "set", new_text)


# Set heading of plane on text change
func _on_heading_value_text_submitted(new_text):
	new_text = int(new_text)
	
	if new_text > heading_max:
		new_text = heading_max
	if new_text < heading_min:
		new_text = heading_min
	
	heading_textedit.text = str(new_text)
	
	var plane
	plane = get_plane()
	plane.set_heading(new_text)
	
	# Reset plane data on landing canceled
	cancel_landing(plane)
	
	Logger.write_to_log("heading", "set", new_text)
	Logger.write_to_console("heading", "set", new_text)


# Set speed of plane on text change
func _on_speed_value_text_submitted(new_text):
	new_text = int(new_text)
	
	if new_text > speed_max:
		new_text = speed_max
	if new_text < speed_min:
		new_text = speed_min
	
	speed_textedit.text = str(new_text)
	
	var plane
	plane = get_plane()
	plane.set_speed(new_text)
	
	# Reset plane data on landing canceled
	cancel_landing(plane)
	
	Logger.write_to_log("speed", "set", new_text)
	Logger.write_to_console("speed", "set", new_text)


# Direct to selected -> plane gets sent to it
func _on_direct_value_item_selected(index):
	var plane
	var point
	
	point = nav_points_list[str(direct_to_options.get_item_text(index))]
	land_options.select(0)
	
	plane = get_plane()
	plane.direct_to(point)
	
	# Reset plane data on landing canceled
	cancel_landing(plane)
	
	Logger.write_to_log("fly towards nav_point", "set", point.name)
	Logger.write_to_console("fly towards nav_point", "set", point.name)


# Runway selected -> plane gets sent to it
func _on_land_item_selected(index):
	var plane
	var point
	
	point = runways_list[str(land_options.get_item_text(index))]
	direct_to_options.select(0)
	
	plane = get_plane()
	plane.direct_to(point)
	plane.add_to_group("land")
	
	Logger.write_to_log("land on runway", "set", point.name)
	Logger.write_to_console("land on runway", "set", point.name)
