# Traffair 
- Author: **Erik Vaněk**
- Made in: **Godot 4.2.1** in **2024**
- This is a final project for my highschool **Střední průmyslová škola elektrotechnická Ječná** (SPŠE Ječná)
## Technologies
- Godot 4.2.1
  - GDScript
- Photoshop
## Installation
- Download the [latest release here](https://github.com/NeDDy3z/Traffair/releases/latest) 
  - the game is exported for Windows, Linux and Linux (ARM architecture)
  - it is also a single file
- Execute the **Traffari_Windows.exe** or **Traffair_Linux.x86_64**, and the game will start
## Requirements
- Windows or Linux runnig x86_64 or (Linux) ARM architecture 
## Configuration
- Game can be configured via few basic settings:
  - Window Mode, Resolution, Vsync, Max FPS, Brightness, SFX volume, Music volume, Debug, Logging
- All of these settings can be edited by a user in the game (in settings submenu) and in file, however, it is strongly discouraged to edit the configuration file itself as a small mistake can result in a reseting the configuration to its default state
- File is located in the user folder: **%appdata%/Godot/app_userdata/Traffair/settings/settings.conf**
- Here's a default example of settings.conf:
```json
{
	"window_mode": "window",
	"resolution": "1920 x 1080",
	"vsync": "on",
	"fps": 60,
	"brightness": 1.1,
	"sfx": 50,
	"music": 50,
	"debug": false,
	"logging": true
}
```
## Code
### Game course
At the beginning of each game, when a Game Level is loaded, the script of the Game Level initiates a timer that regularly triggers a spawning events on its timeout.
When the spawning event triggers there is a X% chance of new plane appearing, time cycles and the probability of plane spawn are adjustable parameters.

When an aircraft spawns, the plane script ensures that the new aircraft receives randomly generated data, such as its callsign, altitude, and speed. 
Additionally, the aircraft is assigned a target destination known as the target_point. This destination is randomly determined, made so that the plane is always guided towards the center of the map, often in the direction of an airport.

For clarity and the smooth functioning of the game, it's crucial that players have access to up-to-date information about the aircrafts. 
This functionality is provided by the Sidebar which shows all the contacted planes as tabs, and it regularly updates information about each aircraft.
Planes also have their data right on them, but to recieve all necessary data, player has to "contact" them for them to appear in the sidebar.
To retrieve data from a specific aircraft, any script can call the get_plane_data function to obtain the desired information from a plane. 
This mechanism enables other parts of the game to efficiently utilize information about the movement and status of aircraft.
### Logging
Basic logging is used to write to file and console what is happening in the game for the debugging purposes. 

Log files are located in a user folder **%appdata%\Godot\app_userdata\Traffair\my_logs\***
### LOC used with _--by-file_:
```
------------------------------------------------------------------------------------------
File                                                   blank        comment           code
------------------------------------------------------------------------------------------
.\logic\plane\plane.gd                                   112             44            277
.\logic\bonus\bonus_advice.gd                             11              4            235
.\logic\ui\game_ui_description.gd                         95             27            234
.\logic\bonus\bonus_riddle.gd                             11              3            229
.\logic\settings.gd                                       84             31            195
.\logic\main_menu\main_menu_settings.gd                  106             61            193
.\logic\main_menu\main_menu_tutorial.gd                   44             26            149
.\logic\levels\runway.gd                                  36              7             86
.\logic\main_menu\main_menu_keybinds.gd                   46             13             83
.\logic\log.gd                                            26             12             74
.\logic\ui\game_ui.gd                                     36             17             69
.\logic\bonus\bonus_airport_prg.gd                        26              6             63
.\logic\ui\game_ui_controls.gd                            29              8             61
.\logic\levels\game_level_kbely.gd                        27              8             59
.\logic\levels\game_level_ruzyne.gd                       26              8             59
.\logic\input.gd                                          32              6             54
.\logic\bonus\bonus_holiday.gd                            25              6             53
.\logic\plane\plane_tab.gd                                22              7             46
.\logic\bonus\bonus_weather_prg.gd                        26              6             43
.\logic\bonus\bonus_dad_joke.gd                           23              6             40
.\logic\bonus\bonus_fact.gd                               23              6             40
.\logic\bonus\bonus_name_day.gd                           23              6             40
.\logic\bonus\bonus_quote.gd                              22              6             40
.\logic\main_menu\main_menu.gd                            33              9             39
.\logic\plane\plane_description.gd                        21              7             38
.\logic\main_menu\main_menu_credits.gd                    23              7             37
.\logic\math.gd                                           14              2             32
.\logic\sound.gd                                          20              3             29
.\logic\plane\plane_explosion.gd                          17              4             27
.\logic\main_menu\main_menu_bonus.gd                      20              8             26
.\logic\main_menu\main_menu_levels.gd                     22              3             23
.\logic\bonus\bonus_time.gd                               17              4             22
.\logic\global.gd                                          8              2             16
.\logic\plane\target_point.gd                             10              5             11
------------------------------------------------------------------------------------------
SUM:                                                    1116            378           2722
------------------------------------------------------------------------------------------
```
## Game Mechanics
- The goal is to land as many panes as possible
- No specific user skills are required other than being able to click on items and think
### Player input
- Plane Control:
	- To control a plane, player must click on it on the map
	- After clicking on a plane, the plane tab will show in the left sidebar list
	- Selecting the planes tab, player now can control a plane through the following means:
		- **altitude**
			- set the height at which the plane travels at
			- select by pressing A
		- **heading**
			- set the specific direction in 0-360° the planes is headed
			- select by pressing D
		- **speed**
			- set speed of the plane in knots
			- select by pressing S
		- **direct to & land**
			- set to which point the plane will travel towards
			- it can either be **Direct point** or **Runway point**
			- the plane will turn towards the point and keeps itself traveling towards unless you give it a different command
			- select by pressing K / L
		- **hold**
			- set plane to a holding pattern
			- the plane will keep circling on a spot in a oval shape
			- select by pressing H
- Game Control:
	- At the bottom of the sidebar are 3 game control buttons
		- **speedup** 
			- game can run at this speed **1x, 2x, 5x, 10x, 15x, 20x**
			- left click increases the speed by a step
			- right click decreases the speed by a step
		- **pause**
			- freeze the game
		- **exit**
			- return to main menu
- Default Key Map:
	- **A** - set focus on altitude
	- **D** - set focus on heading
	- **S** - set focus on speed
	- **K** - set focus on direct to
	- **L** - set focus on land
	- **H** - set focus on hold
	- **Arrow Right** - Speedup a game by a step forward
	- **Arrow Left** - Speedup a game by a step backward 
	- **P** - Pause the game
### Maps
- Maps consist of:
	- **airport**
	- **runway(s)**
		- where every runway has two landing points
	- **direction points**
- Maps have a spawn rate & spawn chance for spawning planes
	- spawn rate & chance varies by a map
		- these variables are not presented to the player
	- *for example: every 15 seconds a planes has 50% chance to spawn*
- Player can navigate planes towards runway (points) to land an airplane
### Planes
- Randomly spawning outside the players view
	- they have a % chance to spawn every x seconds
- Plane is given a random _ at spawn:
	- callsign - consisting of 1-3 random letters and 1-5 random numbers
	- altitude
	- speed
- Once the plane spawns it travels towards the airport
- Planes on a altitude differing by 200ft+- will collide resulting in a points deduction
- Land a plane by passing it through one of the **Runway points**
	- **however, in order to land the plane must fly below 6000ft and below 150kt**
#### Sidebar
- In the left sidebar are shown all tabs of "contacted planes"
- Clicking on a tab (or a plane directly), player can control a plane with the bottom popup window
#### Points counter & Timer
- Point counter tracks how many planes have landed or collided with each other
	- for every plane landed its **+1** point
	- for every plane collision its **-1** point
		- *usually two planes collide so the result is  -2 points*
- Timer tracks the time spent in a level
## Art
- 2D clean art style
- The goal was to achieve an 2D pixelated artstyle of a videogame "Papers Please" or "Ministry of Broadcast" unfortunately I had to prioritize coding over visuals due to this project being the final assignment for my school
### Textures
- All textures and images are made by me in Photoshop
	- *except the background image in the main menu*
### Sound
- Outsourced from the youtube
- All sound effects and music used is Copyright Free and is free to use
## License
- Free to use
- Do not redistribute
