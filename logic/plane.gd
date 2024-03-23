extends CharacterBody2D


var id
@export_category("Plane data")
@export var callsign = "AAA-0000"
@export var speed = 300
@export var heading = 0
@export var altitude = 33000

var plane_tab_prefab = load("res://assets/plane_tab.tscn")
var queue

var direction
var target_point
var target_offset_x
var target_offset_y

var log_gd = load("res://logic/log.gd")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rng = RandomNumberGenerator.new()
var plane_description_gd 
var game_ui



func _ready():
	# Set ID and increment it
	id = Globals.plane_index
	Globals.plane_index += 1
	
	# Load game_ui script
	game_ui = get_parent().get_node("game_ui")
	
	# Load plane related nodes into variables
	target_point = get_parent().get_node("target_point")
	plane_description_gd = $plane_description
	direction = $direction
	queue = get_parent().get_node("game_ui/timetable/queue_scrollcontainer/queue_vboxcontainer")
	
	# Randomly place a target point
	if !Globals.debug:
		target_offset_x = rng.randf_range(-500, 500)
		target_offset_y = rng.randf_range(-500, 500)
		var new_target_pos_x = target_point.position.x + target_offset_x
		var new_target_pos_y = target_point.position.y + target_offset_y
		
		target_point.position = Vector2(new_target_pos_x, new_target_pos_y)
	
	# Direction & rotation of the plane (go towards target point)
	direction.look_at(target_point.position)
	direction.rotation = global_position.direction_to(target_point.position).angle()


func _process(delta):
	var angle = int(direction.rotation_degrees)
	
	if angle < 0:
		angle += 360
	if angle > 0:
		angle += 90
	if angle > 360:
		angle -= 360
	
	heading = angle
	plane_description_gd.update_data(speed, heading, altitude)


func _physics_process(delta):
	# Move straight (/80 to make the speed of movement more realistic)
	velocity = Vector2(1, 0).rotated(direction.rotation) * speed / 80
	
	# Initiate movement
	move_and_slide()


# Clicked on a new plane, it shows up in the sidebar. If the plane was already contacted, it just selects in the side bar
func _on_button_pressed():
	var plane_tabs = game_ui.get_node("timetable/queue_scrollcontainer/queue_vboxcontainer").get_children()
	var contains = false
	
	for pt in plane_tabs:
		if pt.name == str(id):
			pt.get_child(0).emit_signal("pressed")
			contains = true
	
	if !contains:
		add_new_plane_tab()


func add_new_plane_tab():
	var plane_tab = plane_tab_prefab.instantiate()
	
	plane_tab.name = str(id)
	
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
	
	# Suffixes
	plane_values[1].text += "°"
	plane_values[2].text += " ft"
	plane_values[3].text += " kt"
	
	queue.add_child(plane_tab, true)
	log_gd.write_to_log("plane_tab" + str(id), "added", "")
	log_gd.write_to_console("plane_tab" + str(id), "added", "")
