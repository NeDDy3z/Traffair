extends Control



const tutorials : Array = [
	# Sumup description
	{
		"title" : 
			"Traffair",
		"description" : 
			"This game is a simplified arcade game about Air Traffic Control.\n
			You are given an airspace, and your job is to control airplanes within the airspace.\n
			Your objective is to navigate airplanes to land on your airport.\n
			You will goin points for every landed airplane. If you ignore them you'll lose points once they exit your airspace or collide with each other.\n
			(Taking off airplanes may be added to the game later on.)",
		"image" : null
	},
	
	# Sumup controls
	{
		"title" : 
			"Basic controls",
		"description" : 
			"To navigate plane to landing, you need to contact it first.\n
			Upon clicking on a plane, a tab will show in a sidebar with its callsign and basic information.\n
			Click on the airplanes tab - the more detailed description will appear in a bottom of the sidebar, there you can set the planes course, speed, altitude and navigate it to landing.\n
			Planes are tipically able to land when they're under 6000ft and are going about 150kts",
		"image" : 
			null
	},
	
	# Technique controls
	{
		"title" : 
			"Technique & tips",
		"description" : 
			"Planes naturally take time change their altitude, heading and speed, keep that in mind.\n
			Navigate planes towards direction points, or set them a custom heading, altitude & speed.\n
			To land a plane navigate it to a landing point RWxx, once it passes it, the plane begin a descent and land.\n
			It is better to navigate the plane to face the runway far sooner before you navigate it to landing point.\n
			If there are too many planes at once, you can put plane into a holding pattern.\n",
		"image" : 
			null
	},
	
	# UI Basics 1 - Airspace
	{
		"title" : 
			"UI 1/5",
		"description" : 
			"Most of your screen takes up an birdseye view of your arispace",
		"image" : 
			null
	},

	# UI Basics 2 - Sidebar
	{
		"title" : 
			"UI",
		"description" : 
			"On the left side of the screen is a sidebar, where 'contacted' planes will be shown as tabs",
		"image" : 
			null
	},
	
	# UI Basics 3 - Plane tab
	{
		"title" : 
			"UI",
		"description" : 
			"The planes tab will show when you click on an plane in your airspace view",
		"image" : 
			null
	},
	
	# UI Basics 4 - Plane description
	{
		"title" : 
			"UI",
		"description" : 
			"Click on the planes tab to show description and controls of the plane",
		"image" : 
			null
	},
	
	# UI Basics 5 - Plane control
	{
		"title" : 
			"UI",
		"description" : 
			"Here you can edit an: altitdue / heading / speed or send it to a specific point on the map\n
			",
		"image" : 
			null
	},
	
	# UI Basics 6 - Controls
	{
		"title" : 
			"Game control",
		"description" : 
			"At the bottom of the sidebar are 3 buttons:\n
			 - Time speedup: click on it to speed up a time in stages of 1x, 5x, 10x, 20x\n
			 - Pause: You can pause the game if you're feeling overwhelmed\n
			 - Exit: Go back to main menu",
		"image" : 
			"yey"
	},
]



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_back_pressed():
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	
	
	Logger.write_to_log(name, "open main_menu")
	Logger.write_to_console(name, "open main_menu")

