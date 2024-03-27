extends Control



var runway_0 : Object
var runway_1 : Object
var landing : Object

var game_level : Object
var planes

var log_gd = load("res://logic/log.gd")



# Called when the node enters the scene tree for the first time.
func _ready():
	runway_0 = $rw07
	runway_1 = $rw25
	landing = $landing
	game_level = $"../.."
	planes = get_node("../../planes")


# Retireve plane object
func get_plane(object):
	var pl
	pl = planes.get_children()
	for p in pl:
		if p.name.contains(str(object.name)):
			return p


# On runway point collision its sent to land on runway
func _on_rw_07_body_entered(body):
	if body.is_in_group("plane"):
		body.add_to_group("landing")
		
		var plane 
		plane = get_plane(body.get_node("./"))
		plane.direct_to(landing)


# On runway point collision it's sent to land on runway
func _on_rw_25_body_entered(body):
	if body.is_in_group("plane"):
		body.add_to_group("landing")
		
		var plane 
		plane = get_plane(body.get_node("./").name)
		plane.direct_to(landing)


# When plane "hits" the runway it perishes
func _on_landing_body_entered(body):
	if body.is_in_group("landing"):
		body.queue_free()
