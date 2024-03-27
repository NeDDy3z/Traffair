extends Control



var id = name
var callsign_label : Object
var altitude_label : Object
var heading_label : Object
var speed_label : Object

var planes
var labels
var description



# Called when the node enters the scene tree for the first time.
func _ready():
	planes = get_node("../../../../../planes")
	description = get_node("../../../../").get_node("description")

	callsign_label = $Button/callsign
	altitude_label = $Button/data_hboxcontainer/values_vboxcontainer/altitude_value
	heading_label = $Button/data_hboxcontainer/values_vboxcontainer/heading_value
	speed_label = $Button/data_hboxcontainer/values_vboxcontainer/speed_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var data
	data = get_plane()
	if data != null:
		data = data.get_plane_data()
		update_data(data["callsign"], data["altitude"], data["heading"], data["speed"])


# Get plane by callsign
func get_plane():
	var pl
	pl = planes.get_children()
	var exists
	for p in pl:
		if p.name.contains(callsign_label.text):
			exists = true
			return p
	
	if !exists:
		queue_free()
		description.visible = false
		return null


# Set data of plane to tab
func update_data(u_callsign, u_altitude, u_heading, u_speed):	
	callsign_label.text = str(u_callsign)
	altitude_label.text = str(int(u_altitude))
	heading_label.text = str(int(u_heading))
	speed_label.text = str(int(u_speed))
	
	# Suffixes
	altitude_label.text += " ft"
	heading_label.text += "°"
	speed_label.text += " kt"


# Show description tab
func _on_button_pressed():
	description.visible = true
	description.set_callsign(callsign_label)
	description.emit_signal("draw")
