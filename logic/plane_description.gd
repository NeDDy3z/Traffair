extends Control



const NORMAL = Color("00aeff")
const HOVER = Color("74c8ff")

var labels : Dictionary
var plane
var data

var plane_tab



# Called when the node enters the scene tree for the first time.
func _ready():
	labels = {
		"callsign" : $VBoxContainer/callsign,
		"heading" : $VBoxContainer/HBoxContainer/heading,
		"altitude" : $VBoxContainer/HBoxContainer/altitude
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	plane = get_parent()
	data = plane.get_plane_data()
	if data != null:
		update_data(data["callsign"], data["altitude"], data["heading"])


# Update plane data
func update_data(u_callsign, u_altitude, u_heading):
	# Make heading text 3chars long
	var hdg = str(int(u_heading))
	if len(hdg) == 1:
		hdg = "00" + str(hdg)
	elif len(hdg) == 2:
		hdg = "0" + str(hdg)
	
	# Set data
	labels["callsign"].text = str(u_callsign)
	
	labels["altitude"].text = str(u_altitude)
	labels["altitude"].text += " ft"
	
	labels["heading"].text = str(hdg)
	labels["heading"].text += "°"


# When mouse hovers over the plane the text highlights
func _on_button_mouse_entered():
	for label in labels:
		labels[label].set("theme_override_colors/font_color", HOVER)


# When mouse stops hovering over the plane the text goes back to normal
func _on_button_mouse_exited():
	for label in labels:
		labels[label].set("theme_override_colors/font_color", NORMAL)



