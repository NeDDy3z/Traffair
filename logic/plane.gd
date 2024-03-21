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



func _on_ready():
	# Load nodes into variables
	target_point = $"../target_point"
	plane_description_gd = $plane_description
	direction = $direction
	
	# Direction the plane is going (rotation)
	target_offset_x = rng.randf_range(-500, 500)
	target_offset_y = rng.randf_range(-500, 500)
	direction.look_at(Vector2(target_point.position.x + target_offset_x, target_point.position.y + target_offset_y))

	# Get the rotation and display it as 0-360° in heading
	var dgr = direction.rotation_degrees
	if dgr < 0:
		dgr = dgr * -1
	heading = dgr
	
	print(heading)

func _process(delta):
	# Call function to update data of the plane
	plane_description_gd.update_data(speed, heading, altitude)
	
	# Set rotation based on heading degrees
	"""
	if heading > 180:
		direction.rotation_degrees = (heading - 180) * -1
	else: direction.rotation_degrees = heading
	"""
	

func _physics_process(delta):
	# Move straight (/20 to make it more realistic)
	velocity = Vector2(0, -1).rotated(direction.rotation) * speed / 20
	
	# Initiate movement
	move_and_slide()
