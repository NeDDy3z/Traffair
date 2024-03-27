extends Control



@export var plane_spawn_chance = 50 # in %
@export var plane_spawn_delay_s = 10 # in seconds 

# (*display_fps - ticks are dependent on refreshrate, basicly 60ticks = 1s if monitor is 60hz, 90t = 1s if monitor is 90hz, ...)
var plane_spawn_delay = plane_spawn_delay_s * DisplayServer.screen_get_refresh_rate()
var plane_body_prefab = preload("res://assets/plane_body.tscn")

var log_gd = load("res://logic/log.gd")
var rng = RandomNumberGenerator.new()
var display_size = DisplayServer.window_get_size()
var i = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	log_gd.write_to_log("game_level_kbely", "loaded", "")
	log_gd.write_to_console("game_level_kbely", "loaded", "")
	
	spawn_plane() # Spawn 1st plane


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Spawn plane every so often
func _process(_delta):
	i += 1
	if i > plane_spawn_delay:
		i = 0
		if rng.randi_range(0, 100) < plane_spawn_chance:
			spawn_plane()


# Spawn plane
func spawn_plane():
	var plane
	plane = plane_body_prefab.instantiate()
	
	if Globals.debug:
		plane.position = Vector2(1200, 900)
	else:
		plane.position = random_spawn_position()
	
	get_node("planes").add_child(plane)


# Generate a random position for plane to spawn
func random_spawn_position():
	var x : int
	var y : int
	x = rng.randi_range(-100, display_size.x + 100)
	if x >= 0 and x <= display_size.x:
		if rng.randi()%2 == 1:
			y = display_size.y
		else:
			y = -100
	if x == null && y == null:
		x = 0
		y = 0
	var out = Vector2(x,y)
	return out

