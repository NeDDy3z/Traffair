extends Control



const NORMAL = Color("00aeff")
const HOVER = Color("74c8ff")

@onready var labels  = {
		"callsign" : $VBoxContainer/callsign,
		"heading" : $VBoxContainer/HBoxContainer/heading,
		"altitude" : $VBoxContainer/HBoxContainer/altitude
	}



# Update plane data in real time
func update_data(speed, heading, altitude):
	
	var hdg = str(int(heading))
	if len(hdg) == 1:
		hdg = "00" + str(hdg)
	elif len(hdg) == 2:
		hdg = "0" + str(hdg)
	labels["heading"].text = hdg + "°"
	labels["altitude"].text = str(altitude) +" ft"

# Clicked on a new plane, it shows up in the sidebar
# If the plane was already contacted, it just selects in the side bar
func _on_button_pressed():
	pass



# Button = "plane selection" states
# When mouse hovers over the plane the text highlights
func _on_button_mouse_entered():
	for label in labels:
		labels[label].set("theme_override_colors/font_color", HOVER)

# When mouse stops hovering over the plane the text goes back to normal
func _on_button_mouse_exited():
	for label in labels:
		labels[label].set("theme_override_colors/font_color", NORMAL)
