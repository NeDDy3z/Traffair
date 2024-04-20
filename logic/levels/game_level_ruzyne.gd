extends Control



@export var plane_spawn_chance : int = 50 # in %
@export var plane_spawn_delay_in_s : float = 15 # in seconds 

var plane_body_prefab = preload("res://prefabs/plane_body.tscn")

var planes
var target_point
var spawner
var game_ui

var rng : RandomNumberGenerator
var window_size : Vector2



# Called when the node enters the scene tree for the first time.
func _ready():
	## Initialize variables
	planes = $planes
	target_point = $target_point
	spawner = $spawner
	game_ui = $game_ui
	rng = RandomNumberGenerator.new()
	window_size = size
	
	## Set delay of the spawner [Timer] and start it
	spawner.wait_time = plane_spawn_delay_in_s
	spawner.start()
	
	## Call [code]load_nodes[/code] from GlobalInput script to start registering user input
	GlobalInput.load_nodes(game_ui)
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


## Spawn a [plane_body.tsnc] prefab
func spawn_plane():
	var plane
	plane = plane_body_prefab.instantiate()
	
	if Global.debug:
		plane.position = Vector2(1200, 900)
	else:
		plane.position = random_spawn_position()
	planes.add_child(plane)


## Generate a random spawn position, it is always outside the players view (/the screen size)
## It firstly picks a random X position, then a random Y position
func random_spawn_position():
	var x : int
	var y : int
	x = rng.randi_range(200, window_size.x + 100)
	if (
		x >= 300 
		and x <= window_size.x
	):
		if rng.randi()%2 == 1:
			y = window_size.y
		else:
			y = -10
	else:
		y = rng.randi_range(10, window_size.y-10)
	
	if (
		x == null 
		and y == null
	):
		x = 500
		y = 500
	
	var out = Vector2(x,y)
	
	return out


## Spawner [Timer], once every [Timer.timeout] seconds, theres a X% chance to spawn a plane
func _on_spawner_timeout():
	var random
	random = rng.randi_range(1, 100)
	
	if random < plane_spawn_chance:
		spawn_plane()
		
		
		Logger.write_to_log(name, "random spawn")
		Logger.write_to_console(name, "random spawn")
