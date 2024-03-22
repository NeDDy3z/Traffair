extends CharacterBody2D



@export var speed = 300
@export var heading = 0
@export var altitude = 33000

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var rng = RandomNumberGenerator.new()
var plane_description_gd 
var direction

var target_point
var target_offset_x
var target_offset_y



func _ready():
	# Load nodes into variables
	target_point = get_parent().get_node("target_point")
	plane_description_gd = $plane_description
	direction = $direction
	
	# Randomly place a target point
	target_offset_x = rng.randf_range(-500, 500)
	target_offset_y = rng.randf_range(-500, 500)
	target_point.position = Vector2(target_point.position.x + target_offset_x, target_point.position.y + target_offset_y)
	
	# Direction & rotation of the plane (go towards target point)
	direction.look_at(Vector2(target_point.position.x + target_offset_x, target_point.position.y + target_offset_y))
	direction.rotation = global_position.direction_to(target_point.position).angle()

	

func _process(delta):
	plane_description_gd.update_data(speed, heading, altitude)
	
	var angle = direction.rotation_degrees
	if angle < 0:
		angle += 360
		
	heading = angle + 90
	


func _physics_process(delta):
	# Move straight (/20 to make the speed of movement more realistic)
	velocity = Vector2(1, 0).rotated(direction.rotation) * speed / 20
	
	# Initiate movement
	move_and_slide()

