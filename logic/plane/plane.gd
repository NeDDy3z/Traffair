extends CharacterBody2D



@export_category("[Plane] data")
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

## [Plane] related data
var point : Object = null
var direction : Object
var heading_rotation
var direct : String
var new_alt
var new_hdg
var new_spd

## [Plane] related Objects
var plane_description : Object
var data_timer : Object
var direct_timer : Object
var hold_timer : Object


## Map Nodes
var nav_points : Array
var target_point : Object
var target_offset_x
var target_offset_y

## UI Nodes
var game_ui : Object
var queue : Object

## Etc..
var window_size = DisplayServer.window_get_size()
var rng = RandomNumberGenerator.new()
var speed_up = 1

@onready var direction = $direction
@onready var plane_description = $plane_description
@onready var direct_timer = $direct_timer
@onready var data_timer = $data_timer
@onready var hold_timer = $hold_timer

@onready var plane_tab_prefab = preload("res://prefabs/plane_tab.tscn")
@onready var plane_explosion_prefab = preload("res://prefabs/plane_explosion.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	## Load [Plane] related nodes into variables
	nav_points = get_node("../../nav_points").get_children()
	target_point = get_node("../../target_point")
	game_ui = get_node("../../game_ui")
	queue = game_ui.get_node("timetable/queue_scrollcontainer/queue_vboxcontainer")
	
	## Start timers
	direct_timer.start()
	data_timer.start()
	
	## Randomly place a target point to which the [Plane] will direct to (only used for spawning)
	if (heading == null or heading == 0) and !Global.debug:
		target_offset_x = rng.randf_range(500+300, 1000+300)
		target_offset_y = rng.randf_range(300, 800)
		target_point.position = Vector2(target_offset_x, target_offset_y)
		
		## Direction & rotation of the [Plane] (go towards target point)
		direction.look_at(target_point.position)
		direction.rotation = global_position.direction_to(target_point.position).angle()
	else:
		direction.rotation_degrees = Math.deg_to_rot(heading)
	
	
	## Set description of an air[Plane]
	callsign = generate_callsign()
	status = states["fly"]
	
	if altitude == null or altitude == 0:
		altitude = generate_altitude()
	if speed == null or speed == 0:
		speed = generate_speed()
	
	## Set ID & node name; and increment it
	name = "plane_"+callsign
	Global.plane_index += 1



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	## Set heading based on rotation of [Direction] Node
	if heading != Math.rot_to_deg(int(direction.rotation_degrees)):
		heading = Math.rot_to_deg(int(direction.rotation_degrees))


## Moveement
func _physics_process(_delta):
	## Destroy if out of the screen
	if position.x > window_size.x + 500 or position.x < -500:
		queue_free()
	
	if position.y > window_size.y + 500 or position.y < -500:
		queue_free()
	
	## Go faster if outside of the screen to despawn
	if position.x < window_size.x + 20 and position.x > 380:
		speed_up = 1
	else:
		speed_up = 10
	
	if position.y < window_size.y + 10 and position.y > -10:
		speed_up = 1
	else:
		speed_up = 10
	
	## Move straight depending on the direction its looking (/speed_slowdown to make the speed of movement more realistic)
	velocity = ((Vector2(1, 0).rotated(direction.rotation) * speed) / 100) * speed_up ## speed_slowdonw = 80 by default
	## Initiate movement
	move_and_slide()


## Get to retrieve a [Plane] data for other scripts
func get_plane_data():
	return {
		"callsign" : callsign, 
		"altitude" : altitude, 
		"heading" : heading, 
		"speed" : speed,
		"status" : status,
		"direct" : direct
	}


## Slowly transition altitude/heading/speed into a new values ([Plane]s dont immediatly snap - increases the realism)
func slow_update_data():
	## Slowupdate altitude
	if new_alt != null and altitude != new_alt:
		if altitude > new_alt:
			altitude -= 25
			if altitude <= new_alt:
				altitude = new_alt
				new_alt = null
		else:
			altitude += 25
			if altitude >= new_alt:
				altitude = new_alt
				new_alt = null
	
	## Slowupdate speed
	if new_spd != null and speed != new_spd:
		if speed > new_spd:
			speed -= 2
			if speed <= new_spd:
				speed = new_spd
				new_spd = null
		else:
			speed += 2
			if speed >= new_spd:
				speed = new_spd
				new_spd = null
	
	## Slowupdate heading
	if new_hdg != null and heading != new_hdg:
		var difference = (new_hdg%360 - heading%360 + 360) % 360
		
		if difference <= 180:
			heading_rotation += 2
		else:
			heading_rotation -= 2
		
		if difference < 4 or difference >= 358:
			heading_rotation = new_hdg
		
		if heading_rotation != 90:
			direction.rotation_degrees = Math.deg_to_rot(heading_rotation)


## Generate random callsign for [Plane] (for spawning)
func generate_callsign():
	var letters = "abcdefghijklmnopqrstuvwxyz"
	var c_sign : String = ""
	
	for j in rng.randi_range(1,3):
		c_sign += letters[rng.randi_range(0,len(letters)-1)].to_upper()
	
	for j in rng.randi_range(1,4):
		c_sign += str(rng.randi_range(1,9))
	
	return c_sign


## Generate random altitude for [Plane] (for spawning)
func generate_altitude():
	var alt = rng.randi_range(3, 30) * 1000
	
	return alt


## Generate random speed for [Plane] (for spawning)
func generate_speed():
	var spd = rng.randi_range(150,350)
	
	return spd


## Set point, the [Plane] will fly towards
func set_point(value):
	point = value


## Set altitude of [Plane]
func set_altitude(value):
	new_alt = int(value)


## Set heading of [Plane]
func set_heading(value):
	new_hdg = int(value)
	heading_rotation = heading


## Set speed of [Plane]
func set_speed(value):
	new_spd = int(value)


## Set status of [Plane]
func set_status(value):
	status = states[str(value)]


## Set a point to which [Plane] flys toward
func direct_to(value):
	if value != null:
		## Set the [Plane]s direction
		set_heading(Math.rot_to_deg(rad_to_deg(global_position.direction_to(value.global_position).angle())))
		
		## Show in game_ui_description where the [Plane] is going
		direct = value.name.to_upper()  


## Put [Plane] into holding pattern
func hold():
	cancel_landing()
	status = states["hold"]
	
	set_heading(Math.rot_to_deg(direction.rotation_degrees * -1))


## Cancel landing
func cancel_landing():
	if is_in_group("land"):
		remove_from_group("land")
	if is_in_group("landing"):
		remove_from_group("landing")
	
	direct = ""
	status = states["fly"]


## Hide and freeze the [Plane]
func hide_and_freeze():
	speed = 0
	get_node("body").visible = false
	direction.visible = false
	plane_description.visible = false


## [Plane] button pressed - If the [Plane] was not previously interacted with, new plane_tab will appear in Game_UI sidebar
##                      - Select plane_tab in GAME_UI sidebar when the [Plane] was interacted with already
func _on_plane_button_pressed():
	var plane_tabs = game_ui.get_node("timetable/queue_scrollcontainer/queue_vboxcontainer").get_children()
	var contains = false
	
	for pt in plane_tabs:
		print(pt.name, name)
		if pt.name == "plane_tab"+str(name.replace("plane_","")):
			pt.get_child(0).emit_signal("pressed")
			contains = true
	
	if !contains:
		game_ui.add_plane_tab(self)
		plane_tabs = game_ui.get_node("timetable/queue_scrollcontainer/queue_vboxcontainer").get_children()
		plane_tabs[plane_tabs.size()-1].get_child(0).emit_signal("pressed")


## Collision
func _on_area_2d_body_entered(body):
	if body.is_in_group("[Plane]") and name != body.name and (altitude - body.altitude <= 150 and  altitude - body.altitude >= -150):
		
		var explosion = plane_explosion_prefab.instantiate()
		explosion.position = position
		get_parent().add_child(explosion)
		
		hide_and_freeze()
		queue_free()
		body.queue_free()



## Update data every x seconds the timer is set to
func _on_timer_timeout():
	slow_update_data()


## Send [Plane] towards point every x seconds (so it turns to it at all times)
func _on_direct_timer_timeout():
	direct_to(point)


## Turn 180° every x seconds
func _on_hold_timer_timeout():
	hold()
