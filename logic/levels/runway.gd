extends Control


var runways : Array
var runway_0 : Object
var runway_1 : Object
var landing : Object

var game_level : Object
var planes : Object
var game_ui : Object
var land : Object



# Called when the node enters the scene tree for the first time.
func _ready():
	runways = get_children()
	runway_0 = runways[runways.size()-2]
	runway_1 = runways[runways.size()-1]
	landing = $landing
	game_level = $"../.."

	planes = get_node("../../planes")
	game_ui = get_node("../../game_ui")
	land = game_ui.get_node("description/commands/land")
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Retireve plane object
func get_plane(object):
	var pl
	pl = planes.get_children()
	for p in pl:
		if p.name.contains(str(object.name)):
			return p


func can_land(plane_data):
	if (
		plane_data["altitude"] <= 6000 
		and plane_data["speed"] <= 150
	):
		return true
		
	else:
		return false


# On runway point collision its sent to land on runway
func _on_rw_07_body_entered(body):
	if (
		body.is_in_group("plane") 
		and body.is_in_group("land")
	):
		var plane 
		var plane_data
		plane = get_plane(body.get_node("./"))
		plane_data = plane.get_plane_data()
		
		if can_land(plane_data):
			land.select(0)
			
			plane.set_point(landing)
			body.add_to_group("landing")
			
			plane.set_status("landing")
			plane.set_altitude(0)
			plane.set_speed(150)
			
			game_ui.description.disable_input(plane)
			
			
			Logger.write_to_log(name, "RW07 - plane land", plane.name)
			Logger.write_to_console(name, "RW07 - plane land", plane.name)
		else:
			plane.set_status("error")
			
			Logger.write_to_log(name, "RW07 - plane pass", plane.name)
			Logger.write_to_console(name, "RW07 - plane pass", plane.name)


# On runway point collision it's sent to land on runway
func _on_rw_25_body_entered(body):
	if (
		body.is_in_group("plane") 
		and body.is_in_group("land")
	):
		var plane 
		var plane_data
		plane = get_plane(body.get_node("./"))
		plane_data = plane.get_plane_data()
		
		if can_land(plane_data):
			land.select(0)
			
			plane.set_point(landing)
			body.add_to_group("landing")
			
			plane.set_status("landing")
			plane.set_altitude(0)
			plane.set_speed(150)
			
			game_ui.description.disable_input(plane)
			
			
			Logger.write_to_log(name, "RW25 - plane land", plane.name)
			Logger.write_to_console(name, "RW25 - plane land", plane.name)
		else:
			plane.set_status("error")
			
			Logger.write_to_log(name, "RW25 - plane pass", plane.name)
			Logger.write_to_console(name, "RW25 - plane pass", plane.name)


# When plane "hits" the runway it perishes
func _on_landing_body_entered(body):
	if body.is_in_group("landing"):
		body.queue_free()
		game_ui.counter_add()
		
		
		Logger.write_to_log(name, "plane landed", body.name)
		Logger.write_to_console(name, "plane landed", body.name)
