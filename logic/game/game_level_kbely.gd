extends Control



@export var plane_spawn_chance : int = 75 # in %
@export var plane_spawn_delay_in_s : float = 10 # in seconds 

var plane_body_prefab = preload("res://prefabs/plane_body.tscn")

var planes
var target_point
var spawner

var rng = RandomNumberGenerator.new()
var window_size = DisplayServer.window_get_size()



# Called when the node enters the scene tree for the first time.
func _ready():
	planes = $planes
	target_point = $target_point
	spawner = $spawner
	
	target_point.visible = false
	spawner.wait_time = plane_spawn_delay_in_s
	spawner.start()
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Spawn plane
func spawn_plane():
	var plane
	plane = plane_body_prefab.instantiate()
	
	if Global.debug:
		plane.position = Vector2(1200, 900)
	else:
		plane.position = random_spawn_position()
	
	planes.add_child(plane)


# Generate a random position for plane to spawn
func random_spawn_position():
	var x : int
	var y : int
	x = rng.randi_range(-100, window_size.x + 100)
	if x >= 0 and x <= window_size.x:
		if rng.randi()%2 == 1:
			y = window_size.y
		else:
			y = -100
	if x == null && y == null:
		x = 0
		y = 0
	var out = Vector2(x,y)
	return out


# Spawn delay, intiate random pick every x seconds the timer is set to
func _on_spawner_timeout():
	var random
	random = rng.randi_range(1, 100)
	if random < plane_spawn_chance:
		spawn_plane()
		
		
		Logger.write_to_log(name, "random spawn")
		Logger.write_to_console(name, "random spawn")
