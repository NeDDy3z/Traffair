extends Control



var id = name
var callsign : String
var speed : String
var heading : String
var altitude : String

var planes
var description



# Called when the node enters the scene tree for the first time.
func _ready():
	planes = get_node("../../../../../planes")
	description = get_node("../../../../").get_node("description")

	callsign = $Button/callsign.text
	altitude = $Button/data_hboxcontainer/values_vboxcontainer/altitude_value.text
	heading = $Button/data_hboxcontainer/values_vboxcontainer/heading_value.text
	speed = $Button/data_hboxcontainer/values_vboxcontainer/speed_value.text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var data = get_plane().get_plane_data()
	if data != null:
		update_data(data["callsign"], data["altitude"], data["heading"], data["speed"])


# Get plane by callsign
func get_plane():
	var pl = planes.get_children()
	for p in pl:
		if p.name.contains(callsign):
			return p


# Set data of plane to tab
func update_data(u_callsign, u_altitude, u_heading, u_speed):	
	callsign = str(u_callsign)
	altitude = str(int(u_altitude))
	heading = str(int(u_heading))
	speed = str(int(u_speed))
	
	# Suffixes
	heading += "°"
	altitude += " ft"
	speed += " kt"


# Show description tab
func _on_button_pressed():
	description.visible = true
	description.update_data(callsign, int(altitude), int(heading), int(speed), "")
