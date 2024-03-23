extends Control



var plane_body_prefab = preload("res://assets/plane_body.tscn")
var i = 0
var plane_spawn_chance = 100 # in %
var plane_spawn_delay_s = 1 # in seconds 

var plane_spawn_delay = plane_spawn_delay_s * DisplayServer.screen_get_refresh_rate() # (*display_fps - ticks are dependent on refreshrate, basicly 60ticks = 1s if monitor is 60hz, 90t = 1s if monitor is 90hz, ...)

var log_gd = load("res://logic/log.gd")
var rng = RandomNumberGenerator.new()
var display_size = DisplayServer.screen_get_size()


# Called when the node enters the scene tree for the first time.
func _ready():
	log_gd.write_to_log("game_level_kbely", "loaded", "")
	log_gd.write_to_console("game_level_kbely", "loaded", "")
	
	var plane = plane_body_prefab.instantiate()
	plane.position = Vector2(1200,500)
	add_child(plane)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	i += 1
	if i > plane_spawn_delay:
		i = 0
		if rng.randi_range(0,100) < plane_spawn_chance:
			spawn_plane()


func spawn_plane():
	var plane = plane_body_prefab.instantiate()
	#plane.position = random_spawn_position()
	plane.position = Vector2(1200,500)
	#add_child(plane)
	log_gd.write_to_log("plane", "spawn", "")
	log_gd.write_to_console("plane", "spawn", "")


func random_spawn_position():
	var x = rng.randi_range(-100, display_size.x+100)
	var y
	if x >= 0 and x <= display_size.x:
		if rng.randi()%2 == 1:
			y = display_size.y + 100
		else:
			y = -100
	
	return Vector2(x,y)
