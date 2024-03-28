extends Node



# Convert Godot Engine rotation value (-180,-90,0,90,180) to degrees (0,360)
func rotation_to_deg(value):
	var angle
	angle = int(value)
	
	if angle < 0:
		angle += 360
	if angle > 0:
		angle += 90
	if angle > 360:
		angle -= 360
	
	return angle


# Convert degrees (0,360) to Godot Engine rotation value (-180,-90,0,90,180)
func deg_to_rotation(value):
	var angle
	angle = value
	
	if angle <= 360 && angle >= 270:
		angle -= 360
	angle -= 90
	
	return angle



