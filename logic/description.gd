extends Control



var callsign : Object
var altitude : Object
var heading : Object
var speed : Object
var direct_to
var requirement

var log_gd = load("res://logic/log.gd")
var planes


# Called when the node enters the scene tree for the first time.
func _ready():
	callsign = $callsign
	altitude = $data/values/altitude_value
	heading = $data/values/heading_value
	speed = $data/values/speed_value
	direct_to = $data/values/direct_value
	requirement = $requirement/req_value
	
	planes = get_node("../../planes")
	
	log_gd.write_to_log("game_ui_description", "loaded", "")
	log_gd.write_to_console("game_ui_description", "loaded", "")


# Update plane data
func update_data(u_callsign, u_altitude, u_heading, u_speed, u_requirement):
	callsign.text = u_callsign
	altitude.text = str(int(u_altitude))
	heading.text = str(int(u_heading))
	speed.text = str(int(u_speed))
	requirement.text = u_requirement


# Get plane by callsign
func get_plane():
	var pl = planes.get_children()
	for p in pl:
		if p.name.contains(str(callsign.text)):
			return p


# Hide window on "close" press
func _on_close_button_pressed():
	visible = false


# Set altitude of plane on text change
func _on_altitude_value_text_submitted(new_text):
	var plane = get_plane()
	plane.set_altitude(new_text)


# Set heading of plane on text change
func _on_heading_value_text_submitted(new_text):
	var plane = get_plane()
	plane.set_heading(new_text)


# Set speed of plane on text change
func _on_speed_value_text_submitted(new_text):
	var plane = get_plane()
	plane.set_speed(new_text)


# Set direct to (where plane is sent towards) of plane on text change
func _on_direct_value_pressed():
	var plane = get_plane()
	plane.direct_to("test")
