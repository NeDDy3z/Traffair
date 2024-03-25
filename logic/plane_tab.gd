extends Control



var id = name
var callsign : Object
var speed : Object
var heading : Object
var altitude : Object

var planes
var labels
var description



# Called when the node enters the scene tree for the first time.
func _ready():
	planes = get_node("../../../../../planes")
	description = get_node("../../../../").get_node("description")

	labels = {
		"callsign" : $Button/callsign,
		"altitude" : $Button/data_hboxcontainer/values_vboxcontainer/altitude_value,
		"heading" : $Button/data_hboxcontainer/values_vboxcontainer/heading_value,
		"speed" : $Button/data_hboxcontainer/values_vboxcontainer/speed_value
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var data
	data = get_plane().get_plane_data()
	if data != null:
		update_data(data["callsign"], data["altitude"], data["heading"], data["speed"])


# Get plane by callsign
func get_plane():
	var pl
	pl = planes.get_children()
	for p in pl:
		if p.name.contains(labels["callsign"].text):
			return p


# Set data of plane to tab
func update_data(u_callsign, u_altitude, u_heading, u_speed):	
	labels["callsign"].text = str(u_callsign)
	labels["altitude"].text = str(int(u_altitude))
	labels["heading"].text = str(int(u_heading))
	labels["speed"].text = str(int(u_speed))
	
	# Suffixes
	labels["altitude"].text += " ft"
	labels["heading"].text += "°"
	labels["speed"].text += " kt"


# Show description tab
func _on_button_pressed():
	description.visible = true
	description.update_data(labels["callsign"].text, int(labels["altitude"].text), int(labels["heading"].text), int(labels["speed"].text), "")
