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
	"land" : "Landing",
	"hold" : "In holding patter",
	"error" : "ALT / SPD too high for landing (≥4000ft & ≥150kt)"
}

var direct : String
var holding : bool
var new_alt
var new_hdg
var new_spd
var speed_up = 1

var queue : Object
var direction : Object
var nav_points : Array
var target_point : Object
var target_offset_x
var target_offset_y

var plane_tab_prefab = load("res://assets/plane_tab.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var window_size = DisplayServer.window_get_size()
var rng = RandomNumberGenerator.new()
var plane_description : Object
var game_ui : Object
var i : int



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
	# Get heading from object rotation
	var angle
	angle = int(direction.rotation_degrees)
	if angle < 0:
		angle += 360
	if angle > 0:
		angle += 90
	if angle > 360:
		angle -= 360
	heading = angle
	
	# Slowly change the plane altitude/heading/speed
	slow_update_data()


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


# TODO: HEADING UPDATE
# Slowly transition data altitude/heading/speed into a new values (to feel more realistic)
func slow_update_data():
	i += 1
	if i == int(DisplayServer.screen_get_refresh_rate()):
		i = 0
		if altitude != new_alt and new_alt != null:
			if altitude > new_alt:
				altitude -= 200
			else:
				altitude += 200
		if heading != new_hdg and new_hdg != null:
			heading = new_hdg 
		if speed != new_spd and new_spd != null:
			if speed > new_spd:
				speed -= 5
				if speed <= new_spd:
					speed = new_spd
			else:
				speed += 5
				if speed >= new_spd:
					speed = new_spd


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


# Set data of plane
func set_altitude(value):
	new_alt = int(value)
	
	Logger.write_to_log("set_altitude()", "set", value)
	Logger.write_to_console("set_altitude()", "set", value)


# Set heading of plane
func set_heading(value):
	new_hdg = int(value)
	
	Logger.write_to_log("set_altitude()", "set", value)
	Logger.write_to_console("set_altitude()", "set", value)


# Set speed of plane
func set_speed(value):
	new_spd = int(value)
	
	Logger.write_to_log("set_speed()", "set", value)
	Logger.write_to_console("set_speed()", "set", value)


# Set statu of plane
func set_status(value):
	status = states[value]
	
	Logger.write_to_log("set_status()", "set", value)
	Logger.write_to_console("set_status()", "set", value)


# Send plane towards a point
func direct_to(point):
	if point != null:
		# Set the planes path
		direction.look_at(point.position)
		direction.rotation = global_position.direction_to(point.global_position).angle()
		# Show in game_ui_description where the plane is going
		direct = point.name.to_upper() 
		
		status = states["direct"]

		Logger.write_to_log("direct_to()", "set", direct)
		Logger.write_to_console("direct_to()", "set", direct) 


# Intiate holding pattern
func hold():
	direct = ""
	status = states["hold"]
	
	if is_in_group("land"):
		remove_from_group("land")
	if is_in_group("landing"):
		remove_from_group("landing")
	
	
	
	Logger.write_to_log("hold()", "set holding pattern")
	Logger.write_to_console("hold()", "set holding pattern")


# Cancel landing
func cancel_landing():
	remove_from_group("land")
	remove_from_group("landing")
	
	status = states["fly"]


# Add new plane tab
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


# Clicked on a new plane, it shows up in the sidebar. If the plane was already contacted, it just selects in the side bar
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
