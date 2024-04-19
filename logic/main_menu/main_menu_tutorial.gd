extends Control



const tutorials : Dictionary = {
	# Sumup description
	"game" : 
		{
			"title" : 
				"Traffair",
			"description" : 
				"This game is a simplified arcade game about Air Traffic Control.
				You are given an airspace, and your job is to control airplanes within the airspace,
					and your objective is to navigate them to land on your airport.
				You will gain points for every landed airplane. If you ignore them you'll lose points once they exit your airspace or collide with each other.
				(Taking off airplanes may be added to the game later on.)",
			"image" : null
		},
	
	# Sumup controls
	"basics" :
		{
			"title" : 
				"Basic controls",
			"description" : 
				"To navigate plane to landing, you need to contact it first.
				Upon clicking on a plane, a tab will show in a sidebar with its callsign and basic information.
				Click on the airplanes tab - the more detailed description will appear in a bottom of the sidebar, there you can set the planes course, speed, altitude and navigate it to landing.
				Navigate planes towards direction points, or set them a custom heading, altitude & speed.
				Planes are tipically able to land when they're under 6000ft and are going about 150kts",
			"image" : 
				null
		},
	
	# Technique controls
	"tips" :
		{
			"title" : 
				"Technique & tips",
			"description" : 
				"Planes naturally take time change their altitude, heading and speed, keep that in mind.
				To land a plane navigate it to a landing point RWxx, once it passes it, the plane begin a descent and land.
				It is better to navigate the plane to face the runway far sooner before you navigate it to landing point.
				If there are too many planes at once, you can put plane into a holding pattern.",
			"image" : 
				null
		},
	
	# UI Basics 1 - Airspace
	"ui_1" :
		{
			"title" : 
				"UI 1/5",
			"description" : 
				"Most of your screen takes up an birdseye view of your arispace",
			"image" : 
				null
		},
	
	# UI Basics 2 - Sidebar
	"ui_2" :
		{
			"title" : 
				"UI 2/5",
			"description" : 
				"On the left side of the screen is a sidebar, where 'contacted' planes will be shown as tabs",
			"image" : 
				null
		},
	
	# UI Basics 3 - Plane tab
	"ui_3" :
		{
			"title" : 
				"UI 3/5",
			"description" : 
				"The planes tab will show when you click on an plane in your airspace view",
			"image" : 
				null
		},
	
	# UI Basics 4 - Plane description
	"ui_4" : 
		{
			"title" : 
				"UI 4/5",
			"description" : 
				"Click on the planes tab to show description and controls of the plane",
			"image" : 
				null
		},
	
	# UI Basics 5 - Plane control
	"ui_5" :
		{
			"title" : 
				"UI 5/5",
			"description" : 
				"Here you can edit an: altitdue / heading / speed or send it to a specific point on the map
				",
			"image" : 
				null
		},
	
	# UI Basics 6 - Controls
	"ui_6" :
		{
			"title" : 
				"Game control",
			"description" : 
				"At the bottom of the sidebar are 3 buttons:
				 - Time speedup: click on it to speed up a time in stages of 1x, 5x, 10x, 20x
				 - Pause: You can pause the game if you're feeling overwhelmed
				 - Exit: Go back to main menu",
			"image" : 
				"yey"
		}
}

var scroll_container
var scroll_vboxcont
var containers : Array

var title_0
var description_0
var image_0

var main_menu



# Called when the node enters the scene tree for the first time.
func _ready():
	scroll_container = $ScrollContainer
	scroll_vboxcont = $ScrollContainer/scroll_VBoxContainer
	
	main_menu = Global.main_menu_paths["main_menu"]
	
	# All containers into an array
	for child in scroll_vboxcont.get_children():
		containers.append(child)
	
	# Decalre most used container
	title_0 = containers[0].get_child(0)
	description_0 = containers[0].get_child(1)
	image_0 = containers[0].get_child(2)
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Clear text show using other buttons
func clear_contents():
	for c in containers:
		c.get_child(0).text = ""
		c.get_child(1).text = ""
		#containers[i].get_child(2)


func _on_game_pressed():
	clear_contents()
	title_0.text = tutorials["game"]["title"]
	description_0.text = tutorials["game"]["description"]
	#image_0.image = tutorials[0]["image"] 
	
	
	Logger.write_to_log(name, "game description")
	Logger.write_to_console(name, "game description")


func _on_basics_pressed():
	clear_contents()
	title_0.text = tutorials["basics"]["title"]
	description_0.text = tutorials["basics"]["description"]
	#image_0.image = tutorials[0]["image"] 
	
	
	Logger.write_to_log(name, "game basics")
	Logger.write_to_console(name, "game basics")


func _on_tips_pressed():
	clear_contents()
	title_0.text = tutorials["tips"]["title"]
	description_0.text = tutorials["tips"]["description"]
	#image_0.image = tutorials[0]["image"] 
	
	
	Logger.write_to_log(name, "game tips")
	Logger.write_to_console(name, "game tips")


# TODO
func _on_controls_pressed():
	clear_contents()
	for i in range(0,6):
		containers[i].get_child(0).text = tutorials["ui_"+str(i+1)]["title"]
		containers[i].get_child(1).text = tutorials["ui_"+str(i+1)]["description"]
		#containers[i].get_child(2)
	

	#image.image = tutorials["ui_1"]["image"] 
	
	
	Logger.write_to_log(name, "game description")
	Logger.write_to_console(name, "game description")


# Go back to main_menu
func _on_back_pressed():
	get_tree().change_scene_to_file(main_menu)
	
	
	Logger.write_to_log(name, "open main_menu")
	Logger.write_to_console(name, "open main_menu")
