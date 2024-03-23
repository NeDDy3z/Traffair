extends Control



var id = name
var callsign
var speed
var heading
var altitude

var normal = load("res://art/themes/plane_tab_button.tres::StyleBoxFlat_mxnca")
var hover = load("res://art/themes/plane_tab_button.tres::StyleBoxFlat_kivkm")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func add_plane_tab(id, callsign, heading, altitude, speed):
	var plane_values = [
		get_node("callsign"),
		get_node("data_hboxcontainer/values_vboxcontainer/heading_value"),
		get_node("data_hboxcontainer/values_vboxcontainer/altitude_value"),
		get_node("data_hboxcontainer/values_vboxcontainer/speed_value")
	]
	
	# Set data of plane to tab
	plane_values[0].text = callsign
	plane_values[1].text = heading
	plane_values[2].text = altitude
	plane_values[3].text = speed


func update_plane_tab(u_callsign, u_heading, u_altitude, u_speed):
	# Set data of plane to tab
	callsign = str(u_callsign)
	heading = str(int(u_heading))
	altitude = str(u_altitude)
	speed = str(u_speed)
	
	# Suffixes
	heading += "°"
	altitude += " ft"
	speed += " kt"


func _on_button_pressed():
	pass
	# show description tab
