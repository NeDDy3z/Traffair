extends CharacterBody2D



var id : String
@export_category("Plane data")
@export var callsign : String
@export var altitude : int
@export var heading : int
@export var speed : int

var new_alt
var new_hdg
var new_spd

var plane_tab_prefab = load("res://assets/plane_tab.tscn")
var queue

var direction
var target_point
var target_offset_x
var target_offset_y

var log_gd = load("res://logic/log.gd")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rng = RandomNumberGenerator.new()
var i : int
var plane_description
var game_ui



# Called when the node enters the scene tree for the first time.
func _ready():
	# Load game_ui script
	game_ui = get_parent().get_parent().get_node("game_ui")
	
	# Load plane related nodes into variables
	target_point = get_parent().get_parent().get_node("target_point")
	plane_description = $plane_description
	direction = $direction
	queue = game_ui.get_node("timetable/queue_scrollcontainer/queue_vboxcontainer")
	
	
	# Randomly place a target point (to which the plane will direct to)
	if !Globals.debug:
		target_offset_x = rng.randf_range(-500, 500)
		target_offset_y = rng.randf_range(-500, 500)
		var new_target_pos_x = target_point.position.x + target_offset_x
		var new_target_pos_y = target_point.position.y + target_offset_y
		
		target_point.position = Vector2(new_target_pos_x, new_target_pos_y)
	
	# Direction & rotation of the plane (go towards target point)
	direction.look_at(target_point.position)
	direction.rotation = global_position.direction_to(target_point.position).angle()
	
	# Set description of an airplane
	callsign = generate_callsign()
	altitude = generate_altitude()
	speed = generate_speed()
	
	# Set ID & node name; and increment it
	id = callsign
	name = "plane_"+callsign
	Globals.plane_index += 1
	
	log_gd.write_to_log("plane"+callsign, "spawn", "")
	log_gd.write_to_console("plane"+callsign, "spawn", "")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Get heading from object rotation
	var angle = int(direction.rotation_degrees)
	if angle < 0:
		angle += 360
	if angle > 0:
		angle += 90
	if angle > 360:
		angle -= 360
	heading = angle
	
	# Slowly change the plane altitude/heading/speed
	slow_update_data()
	
	# Nonstop update plane data
	plane_description.update_data(callsign, altitude, heading)


func _physics_process(delta):
	# Move straight (/80 to make the speed of movement more realistic)
	velocity = Vector2(1, 0).rotated(direction.rotation) * speed / 80
	# Initiate movement
	move_and_slide()


func get_plane_data():
	return {
		"callsign" : callsign, 
		"altitude" : altitude, 
		"heading" : heading, 
		"speed" : speed
	}


func slow_update_data():
	i += 1
	if i == int(DisplayServer.screen_get_refresh_rate()):
		i = 0
		if altitude != new_alt and new_alt != null:
			if altitude > new_alt:
				altitude -= 500
			else:
				altitude += 500
		
		if speed != new_spd and new_spd != null:
			if speed > new_spd:
				speed -= 5
				if speed <= new_spd:
					speed = new_spd
			else:
				speed += 5
				if speed >= new_spd:
					speed = new_spd
		# TODO: HEADING UPDATE


# Generate random callsign of plane
func generate_callsign():
	var letters = "abcdefghijklmnopqrstuvwxyz"
	var sign : String
	
	for i in rng.randi_range(1,3):
		sign += letters[rng.randi_range(0,len(letters)-1)].to_upper()
	
	for i in rng.randi_range(1,4):
		sign += str(rng.randi_range(1,9))
	return sign


# Generate random altitude of plane
func generate_altitude():
	var alt : int
	alt = rng.randi_range(3, 30) * 1000
	return alt


# Generate random speed of plane
func generate_speed():
	var spd : int
	spd = rng.randi_range(150,350)
	return spd


# Set data of plane
func set_altitude(value):
	new_alt = int(value)


# Set heading of plane
func set_heading(value):
	new_hdg = int(value)


# Set speed of plane
func set_speed(value):
	new_spd = int(value)


# Send plane towards a point
func direct_to(value):
	direction.look_at(value.position)
	direction.rotation = global_position.direction_to(value.position).angle()


func add_new_plane_tab():
	var plane_tab = plane_tab_prefab.instantiate()
	plane_tab.name = "plane_tab"+str(id)
	
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
	log_gd.write_to_log("plane_tab" + str(id), "added", "")
	log_gd.write_to_console("plane_tab" + str(id), "added", "")


# Clicked on a new plane, it shows up in the sidebar. If the plane was already contacted, it just selects in the side bar
func _on_plane_button_pressed():
	var plane_tabs = game_ui.get_node("timetable/queue_scrollcontainer/queue_vboxcontainer").get_children()
	var contains = false
	
	for pt in plane_tabs:
		if pt.name == "plane_tab"+str(id):
			pt.get_child(0).emit_signal("pressed")
			contains = true
	if !contains:
		add_new_plane_tab()
