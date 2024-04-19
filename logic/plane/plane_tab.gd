extends Control



var callsign : Label
var altitude : Label
var heading : Label
var speed : Label

var planes : Object
var description : Object



# Called when the node enters the scene tree for the first time.
func _ready():
	callsign = $Button/callsign
	altitude = $Button/data_hboxcontainer/values_vboxcontainer/altitude_value
	heading = $Button/data_hboxcontainer/values_vboxcontainer/heading_value
	speed = $Button/data_hboxcontainer/values_vboxcontainer/speed_value
	planes = get_node("../../../../../planes")
	description = get_node("../../../../description")
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var data
	data = get_plane()
	if data != null:
		data = data.get_plane_data()
		update_data(data["callsign"], data["altitude"], data["heading"], data["speed"])


# Get plane by callsign
func get_plane():
	var pl
	var exists
	
	pl = planes.get_children()

	for p in pl:
		if p.name.contains(callsign.text):
			exists = true
			return p
	
	if not exists:
		queue_free()
		description.visible = false
		return null


# Set data of plane to tab
func update_data(u_callsign, u_altitude, u_heading, u_speed):	
	callsign.text = str(u_callsign)
	altitude.text = str(int(u_altitude))
	heading.text = str(int(u_heading))
	speed.text = str(int(u_speed))
	
	# Suffixes
	altitude.text += " ft"
	heading.text += "°"
	speed.text += " kt"


# Show description tab
func _on_button_pressed():
	description.visible = true
	description.callsign_reference(callsign)
	description.emit_signal("draw")
