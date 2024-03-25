extends Control


@export_category("Plane data limits")
@export var altitude_min : int = 1500
@export var altitude_max : int = 35000
@export var heading_min : int = 0
@export var heading_max : int = 359
@export var speed_min : int = 110
@export var speed_max : int = 350

var callsign : Object
var altitude : Object
var heading : Object
var speed : Object
var direct_to
var requirement

var log_gd = load("res://logic/log.gd")
var planes
var nav_points


# Called when the node enters the scene tree for the first time.
func _ready():
	callsign = $callsign
	altitude = $data/values/altitude_value
	heading = $data/values/heading_value
	speed = $data/values/speed_value
	direct_to = $data/values/direct_value
	requirement = $requirement/req_value
	
	planes = get_node("../../planes")
	nav_points = get_node("../../nav_points")
	add_nav_points()
	
	log_gd.write_to_log("game_ui_description", "loaded", "")
	log_gd.write_to_console("game_ui_description", "loaded", "")


# Update plane data in sidebar bottom tab
func update_data(u_callsign, u_altitude, u_heading, u_speed, u_requirement):
	callsign.text = str(u_callsign)
	altitude.text = str(u_altitude)
	heading.text = str(u_heading)
	speed.text = str(u_speed)
	requirement.text = u_requirement


# Get plane by callsign
func get_plane():
	var pl
	pl = planes.get_children()
	for p in pl:
		if p.name.contains(str(callsign.text)):
			return p


# Add all nav_points into direct_to optionsbutton
func add_nav_points():
	var n_p
	n_p = nav_points.get_children()
	for i in range(0,len(n_p)):
		direct_to.add_item(n_p[i].name.to_upper(), i)
		
	log_gd.write_to_log("nav_points", "loaded", "")
	log_gd.write_to_console("nav_points", "loaded", "")


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
	
	altitude.text = str(new_text)
	
	var plane
	plane = get_plane()
	plane.set_altitude(new_text)
	
	log_gd.write_to_log("altitude", "set", "")
	log_gd.write_to_console("altitude", "set", "")


# Set heading of plane on text change
func _on_heading_value_text_submitted(new_text):
	new_text = int(new_text)
	
	if new_text > heading_max:
		new_text = heading_max
	if new_text < heading_min:
		new_text = heading_min
	
	heading.text = str(new_text)
	
	var plane
	plane = get_plane()
	plane.set_heading(new_text)
	
	log_gd.write_to_log("heading", "set", "")
	log_gd.write_to_console("heading", "set", "")


# Set speed of plane on text change
func _on_speed_value_text_submitted(new_text):
	new_text = int(new_text)
	
	if new_text > speed_max:
		new_text = speed_max
	if new_text < speed_min:
		new_text = speed_min
	
	speed.text = str(new_text)
	
	var plane
	plane = get_plane()
	plane.set_speed(new_text)
	
	log_gd.write_to_log("speed", "set", "")
	log_gd.write_to_console("speed", "set", "")


func _on_direct_value_item_selected(index):
	var plane
	plane = get_plane()
	plane.direct_to(direct_to.get_item_text(index))
	
	log_gd.write_to_log("direct_to", "set", "")
	log_gd.write_to_console("direct_to", "set", "")
