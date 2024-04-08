extends CharacterBody2D



@export_category("Plane data")
@export var callsign : String
@export var altitude : int
@export var heading : int
@export var speed : int
@export var status : String

var states = {
	"fly" : "Flying through",
	"direct" : "Directed to NAV point",
	"landing" : "Landing",
	"hold" : "In holding pattern",
	"error" : "ALT / SPD too high for landing (≥6000ft & ≥150kt)"
}

# Plane related data
var point : Object = null
var direction : Object
var heading_rotation
var direct : String
var new_alt
var new_hdg
var new_spd

# Plane related Objects
var plane_description : Object
var videoplayer : VideoStreamPlayer
var direct_timer : Object
var data_timer : Object
var plane_tab_prefab : Object

# Map Nodes
var nav_points : Array
var target_point : Object
var target_offset_x
var target_offset_y

# UI Nodes
var game_ui : Object
var queue : Object

# Etc..
var window_size = DisplayServer.window_get_size()
var rng = RandomNumberGenerator.new()
var speed_up = 1




# Called when the node enters the scene tree for the first time.
func _ready():
	# Load plane related nodes into variables
	plane_description = $plane_description
	direction = $direction
	videoplayer = $VideoStreamPlayer
	direct_timer = $direct_timer
	data_timer = $data_timer
	plane_tab_prefab = load("res://prefabs/plane_tab.tscn")
	nav_points = get_node("../../nav_points").get_children()
	target_point = get_node("../../target_point")
	game_ui = get_node("../../game_ui")
	queue = game_ui.get_node("timetable/queue_scrollcontainer/queue_vboxcontainer")
	
	# Start timers
	direct_timer.start()
	data_timer.start()
	
	# Randomly place a target point to which the plane will direct to (only used for spawning)
	if altitude == null:
		if !Global.debug:
			target_offset_x = rng.randf_range(-500, 500)
			target_offset_y = rng.randf_range(-500, 500)
			var new_target_pos_x 
			var new_target_pos_y
			new_target_pos_x = target_point.position.x + target_offset_x
			new_target_pos_y = target_point.position.y + target_offset_y
			
			target_point.position = Vector2(new_target_pos_x, new_target_pos_y)
		
		# Direction & rotation of the plane (go towards target point)
		direction.look_at(target_point.position)
		direction.rotation = global_position.direction_to(target_point.position).angle()
	else:
		direction.rotation_degrees = Math.deg_to_rot(heading)
		
	
	# Set description of an airplane
	callsign = generate_callsign()
	status = states["fly"]
	
	if altitude == null:
		altitude = generate_altitude()
	if speed == null:
		speed = generate_speed()
	
	# Set ID & node name; and increment it
	name = "plane_"+callsign
	Global.plane_index += 1
	
	
	Logger.write_to_console(name, "spawn", "plane_count="+str(Global.plane_index))
	Logger.write_to_log(name, "spawn", "plane_count="+str(Global.plane_index))
	Logger.write_to_console("-")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Set heading based on rotation of [Direction] Node
	if heading != Math.rot_to_deg(int(direction.rotation_degrees)):
		heading = Math.rot_to_deg(int(direction.rotation_degrees))


# Moevement stuff
func _physics_process(_delta):
	# Destroy if out of the screen
	if position.x > window_size.x + 150 or position.x < -150:
		queue_free()
	if position.y > window_size.y + 150 or position.y < -150:
		queue_free()
	
	# Go faster if outside of the screen
	if position.x < window_size.x and position.x > 400:
		speed_up = 1
	else:
		speed_up = 10
	if position.y < window_size.y and position.y > 0:
		speed_up = 1
	else:
		speed_up = 10
	
	# Move straight depending on the direction its looking (/speed_slowdown to make the speed of movement more realistic)
	velocity = ((Vector2(1, 0).rotated(direction.rotation) * speed) / 100) * speed_up # speed_slowdonw = 80 by default
	# Initiate movement
	move_and_slide()


# Getter to retrieve a plane data
func get_plane_data():
	return {
		"callsign" : callsign, 
		"altitude" : altitude, 
		"heading" : heading, 
		"speed" : speed,
		"status" : status,
		"direct" : direct
	}


# Slowly transition altitude/heading/speed into a new values (increases the realism)
func slow_update_data():
	# Slowupdate altitude
	if new_alt != null and altitude != new_alt:
		if altitude > new_alt:
			altitude -= 100
			if altitude <= new_alt:
				altitude = new_alt
				new_alt = null
		else:
			altitude += 100
			if altitude >= new_alt:
				altitude = new_alt
				new_alt = null
	
	# Slowupdate speed
	if new_spd != null and speed != new_spd:
		if speed > new_spd:
			speed -= 5
			if speed <= new_spd:
				speed = new_spd
				new_spd = null
		else:
			speed += 5
			if speed >= new_spd:
				speed = new_spd
				new_spd = null
	
	# Slowupdate heading
	if new_hdg != null and heading != new_hdg:
		var difference 
		difference = (new_hdg%360 - heading%360 + 360) % 360
		
		if difference <= 180:
			heading_rotation += 5
		else:
			heading_rotation -= 5
		
		if difference < 7 or difference >= 358:
			heading_rotation = new_hdg
		
		if heading_rotation != 90:
			direction.rotation_degrees = Math.deg_to_rot(heading_rotation)


# Generate random callsign of plane (for spawning)
func generate_callsign():
	var letters 
	letters = "abcdefghijklmnopqrstuvwxyz"
	var c_sign : String = ""
	
	for j in rng.randi_range(1,3):
		c_sign += letters[rng.randi_range(0,len(letters)-1)].to_upper()
	
	for j in rng.randi_range(1,4):
		c_sign += str(rng.randi_range(1,9))
	
	Logger.write_to_log("generate_callsign()", "generated", c_sign)
	Logger.write_to_console("generate_callsign()", "generated", c_sign)
	
	return c_sign


# Generate random altitude of plane (for spawning)
func generate_altitude():
	var alt : int
	alt = rng.randi_range(3, 30) * 1000
	
	Logger.write_to_log("generate_altitude()", "generated", alt)
	Logger.write_to_console("generate_altitude()", "generated", alt)
	
	return alt


# Generate random speed of plane (for spawning)
func generate_speed():
	var spd : int
	spd = rng.randi_range(150,350)
	
	Logger.write_to_log("generate_speed()", "generated", spd)
	Logger.write_to_console("generate_speed()", "generated", spd)
	
	return spd


func set_point(value):
	point = value
	
	
	Logger.write_to_log(name, "set_point()", value)
	Logger.write_to_console(name, "set_point()", value)


# Set altitude of Plane
func set_altitude(value):
	new_alt = int(value)
	
	
	Logger.write_to_log(name, "set_altitude()", value)
	Logger.write_to_console(name, "set_altitude()", value)


# Set heading of Plane
func set_heading(value):
	new_hdg = int(value)
	heading_rotation = heading
	
	
	Logger.write_to_log(name, "set_altitude()", value)
	Logger.write_to_console(name, "set_altitude()", value)


# Set speed of Plane
func set_speed(value):
	new_spd = int(value)
	
	
	Logger.write_to_log(name, "set_speed()", value)
	Logger.write_to_console(name, "set_speed()", value)


# Set status of Plane
func set_status(value):
	status = states[str(value)]
	
	
	Logger.write_to_log(name, "set_status()", value)
	Logger.write_to_console(name, "set_status()", value)


# Set a point to which Plane flys toward
func direct_to(value):
	if value != null:
		# Set the planes direction
		var angle_rot = rad_to_deg(global_position.direction_to(value.global_position).angle())
		var angle = Math.rot_to_deg(angle_rot)
		set_heading(angle)
		
		# Show in game_ui_description where the plane is going
		direct = value.name.to_upper() 
	
	
	Logger.write_to_log(name, "direct_to()", direct)
	Logger.write_to_console(name, "direct_to()", direct) 


# Put Plane into holding pattern
func hold():
	cancel_landing()
	status = states["hold"]
	
	
	Logger.write_to_log(name, "hold()")
	Logger.write_to_console(name, "hold()")


# Cancel landing
func cancel_landing():
	if is_in_group("land"):
		remove_from_group("land")
	if is_in_group("landing"):
		remove_from_group("landing")
	
	direct = ""
	status = states["fly"]

	
	Logger.write_to_log(name, "cancel_landing()")
	Logger.write_to_console(name, "cancel_landing()")


# Hide and freeze the plane
func hide_and_freeze():
	speed = 0
	get_node("body").visible = false
	direction.visible = false
	plane_description.visible = false
	
	
	Logger.write_to_log(name, "hide_and_freeze()", direct)
	Logger.write_to_console(name, "hide_and_freeze()", direct) 



# Plane button pressed - If the plane was not previously interacted with, new Plane_tab will appear in Game_UI sidebar
#                      - Select plane_tab in GAME_UI sidebar when the Plane was interacted with already
func _on_plane_button_pressed():
	var plane_tabs 
	plane_tabs = game_ui.get_node("timetable/queue_scrollcontainer/queue_vboxcontainer").get_children()
	var contains
	contains = false
	
	for pt in plane_tabs:
		if pt.name == "plane_tab"+str(name):
			pt.get_child(0).emit_signal("pressed")
			contains = true
	if !contains:
		game_ui.add_plane_tab(get_node("."))
		plane_tabs = game_ui.get_node("timetable/queue_scrollcontainer/queue_vboxcontainer").get_children()
		plane_tabs[plane_tabs.size()-1].get_child(0).emit_signal("pressed")


# Collision
func _on_area_2d_body_entered(body):
	if body.is_in_group("plane") and name != body.name \
	and altitude == body.altitude:
		hide_and_freeze()
		
		videoplayer.play()
		Sound.play_explosion()
		game_ui.counter_deduct()
		
		# Wait 2 seconds to play the explosion video
		await get_tree().create_timer(1.5).timeout
		
		body.queue_free()
		queue_free()
		
		
		Logger.write_to_log(name, "collision with another aircraft", body.name)
		Logger.write_to_console(name, "collision with another aircraft", body.name)



# Update data every x seconds the timer is set to
func _on_timer_timeout():
	slow_update_data()


# Send plane towards point every x seconds (so it turns to it at all times)
func _on_direct_timer_timeout():
	direct_to(point)
