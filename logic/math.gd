extends Node



func _ready():
	Logger.write_to_console(name, "loaded")
	Logger.write_to_log(name, "loaded")



## Convert Godot Engine rotation value (-180,-90,0,90,180) to degrees (0,360)
func rot_to_deg(value):
	if value != null:
		var angle
		angle = int(value)
		
		if angle < 0:
			angle += 360
		if angle >= 0:
			angle += 90
		if angle >= 360:
			angle -= 360
		if !Global.log_antispam:
			Logger.write_to_console(name, "converstion rot_to_deg")
			Logger.write_to_log(name, "converstion rot_to_deg")
		
		return angle


## Convert degrees (0,360) to Godot Engine rotation value (-180,-90,0,90,180)
func deg_to_rot(value):
	if value != null:
		var angle
		angle = int(value)
		
		if (
			angle <= 360 
			and angle >= 270
		):
			angle -= 360
		angle -= 90
		
		if !Global.log_antispam:
			Logger.write_to_console(name, "converstion deg_to_rot")
			Logger.write_to_log(name, "converstion deg_to_rot")
		
		return angle

