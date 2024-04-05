extends CharacterBody2D



@export_category("Plane data")
@export var callsign : String
@export var altitude : int
@export var heading : int
@export var speed : int
@export var status : String

var states = { # Enum doesnt work here
	"fly" : "Flying through",
	"direct" : "Directed to NAV point",
	"landing" : "Landing",
	"hold" : "In holding pattern",
	"error" : "ALT / SPD too high for landing (≥6000ft & ≥150kt)"
}

var point : Object
var direct : String
var heading_rotation
var new_alt
var new_hdg
var new_spd

var plane_description : Object
var game_ui : Object
var queue : Object
var direction : Object
var nav_points : Array
var target_point : Object
var target_offset_x
var target_offset_y

var plane_tab_prefab = load("res://assets/plane_tab.tscn")
var window_size = DisplayServer.window_get_size()
var rng = RandomNumberGenerator.new()
var speed_up = 1



# Called when the node enters the scene tree for the first time.
func _ready():
	# Load game_ui script
	game_ui = get_parent().get_parent().get_node("game_ui")
	
	# Load plane related nodes into variables
	queue = game_ui.get_node("timetable/queue_scrollcontainer/queue_vboxcontainer")
	target_point = get_parent().get_parent().get_node("target_point")
	nav_points = get_node("../../nav_points").get_children()
	plane_description = $plane_description
	direction = $direction
	
	# Randomly place a target point (to which the plane will direct to)
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
	
	# Set description of an airplane
	callsign = generate_callsign()
	altitude = generate_altitude()
	speed = generate_speed()
	status = states["fly"]
	
	# Set ID & node name; and increment it
	name = "plane_"+callsign
	Global.plane_index += 1
	
	
	Logger.write_to_log("plane"+callsign, "spawn", "plane_count="+str(Global.plane_index))
	Logger.write_to_console("plane"+callsign, "spawn", "plane_count="+str(Global.plane_index))
	Logger.write_to_console("-","")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Set heading based on rotation of [Direction] Node
	if heading != Math.rotation_to_deg(int(direction.rotation_degrees)):
		heading = Math.rotation_to_deg(int(direction.rotation_degrees))


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


# Getter for all of the scripts to retrieve a plane data
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
			direction.rotation_degrees = Math.deg_to_rotation(heading_rotation)


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


# Set altitude of Plane
func set_altitude(value):
	new_alt = int(value)
	
	
	Logger.write_to_log("set_altitude()", "set", value)
	Logger.write_to_console("set_altitude()", "set", value)


# Set heading of Plane
func set_heading(value):
	new_hdg = int(value)
	heading_rotation = heading
	
	
	Logger.write_to_log("set_altitude()", "set", value)
	Logger.write_to_console("set_altitude()", "set", value)


# Set speed of Plane
func set_speed(value):
	new_spd = int(value)
	
	
	Logger.write_to_log("set_speed()", "set", value)
	Logger.write_to_console("set_speed()", "set", value)


# Set status of Plane
func set_status(value):
	status = states[str(value)]
	
	
	Logger.write_to_log("set_status()", "set", value)
	Logger.write_to_console("set_status()", "set", value)


# Set a point to which Plane flys toward
func direct_to(value):
	if value != null:
		cancel_landing()
		
		# Set the planes direction
		var angle_rot = rad_to_deg(global_position.direction_to(value.global_position).angle())
		var angle = Math.rotation_to_deg(angle_rot)
		set_heading(angle)
		
		# Show in game_ui_description where the plane is going
		direct = value.name.to_upper() 
		status = states["direct"]
		
		
		Logger.write_to_log("direct_to()", "set", direct)
		Logger.write_to_console("direct_to()", "set", direct) 


# Put Plane into holding pattern
func hold():
	cancel_landing()
	point = null
	
	direct = ""
	status = states["hold"]
	
	
	Logger.write_to_log("hold()", "set holding pattern")
	Logger.write_to_console("hold()", "set holding pattern")


# Cancel landing
func cancel_landing():
	if is_in_group("land"):
		remove_from_group("land")
	if is_in_group("landing"):
		remove_from_group("landing")
		direct = ""
		status = states["fly"]
	
	
	Logger.write_to_log("cancel_landing()", "landing canceled")
	Logger.write_to_console("cancel_landing()", "landing canceled")


# Create Plane_tab in Game_UI sidebar
func add_new_plane_tab():
	var plane_tab 
	plane_tab = plane_tab_prefab.instantiate()
	plane_tab.name = "plane_tab"+str(name)
	
	var plane_values = [
		plane_tab.get_node("Button/callsign"),
		plane_tab.get_node("Button/data_hboxcontainer/values_vboxcontainer/heading_value"),
		plane_tab.get_node("Button/data_hboxcontainer/values_vboxcontainer/altitude_value"),
		plane_tab.get_node("Button/data_hboxcontainer/values_vboxcontainer/speed_value")
	]
	
	# Set data of plane to tab
	plane_values[0].text = str(callsign)
	plane_values[1].text = str(int(heading))
	plane_values[2].text = str(altitude)
	plane_values[3].text = str(speed)
	
	# Add tab
	queue.add_child(plane_tab, true)
	Logger.write_to_log("plane_tab" + str(name), "added")
	Logger.write_to_console("plane_tab" + str(name), "added")


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
		add_new_plane_tab()
		plane_tabs = game_ui.get_node("timetable/queue_scrollcontainer/queue_vboxcontainer").get_children()
		plane_tabs[plane_tabs.size()-1].get_child(0).emit_signal("pressed")


# Update data every x seconds the timer is set to
func _on_timer_timeout():
	slow_update_data()


func _on_direct_timer_timeout():
	pass # Replace with function body.
