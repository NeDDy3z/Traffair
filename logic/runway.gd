extends Control



var runway_0 : Object
var runway_1 : Object
var landing : Object

var game_level : Object
var planes
var land



# Called when the node enters the scene tree for the first time.
func _ready():
	runway_0 = $rw07
	runway_1 = $rw25
	landing = $landing
	game_level = $"../.."
	planes = get_node("../../planes")
	
	land =  get_node("../../game_ui/description/commands/land")


# Retireve plane object
func get_plane(object):
	var pl
	pl = planes.get_children()
	for p in pl:
		if p.name.contains(str(object.name)):
			return p


# On runway point collision its sent to land on runway
func _on_rw_07_body_entered(body):
	if body.is_in_group("plane") && body.is_in_group("land"):
		var plane 
		var plane_data
		plane = get_plane(body.get_node("./"))
		plane_data = plane.get_plane_data()
		
		if plane_data["altitude"] <= 6000 && plane_data["speed"] <= 150:
			body.add_to_group("landing")
			land.select(0)
			
			plane.direct_to(landing)
			plane.set_status("landing")
			plane.set_altitude(0)
			plane.set_speed(150)
		else:
			plane.set_status("error")


# On runway point collision it's sent to land on runway
func _on_rw_25_body_entered(body):
	if body.is_in_group("plane") && body.is_in_group("land"):
		var plane 
		var plane_data
		plane = get_plane(body.get_node("./"))
		plane_data = plane.get_plane_data()
		
		if plane_data["altitude"] <= 6000 && plane_data["speed"] <= 150:
			body.add_to_group("landing")
			land.select(0)
			
			plane.direct_to(landing)
			plane.set_status("landing")
			plane.set_altitude(0)
			plane.set_speed(150)
		else:
			plane.set_status("error")


# When plane "hits" the runway it perishes
func _on_landing_body_entered(body):
	if body.is_in_group("landing"):
		body.queue_free()
