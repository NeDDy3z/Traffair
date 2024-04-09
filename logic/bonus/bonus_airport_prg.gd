extends Button



var airport_name : String
var airport_icao : String

var api_link : String
var api_key : String
var HTTP_req : HTTPRequest
var text_label : Label
var headers 



# Called when the node enters the scene tree for the first time.
func _ready():
	HTTP_req = $HTTPRequest
	text_label = $"../../../text_label"
	
	airport_name = "ruzyne"
	airport_icao = "lkpr"
	
	api_link = "https://api.api-ninjas.com/v1/airports?name="+ airport_name +"&icao="+ airport_icao
	api_key = "hR1LjzS5Mqz+5L4x20wTJw==KzbXcGzzS6qKysoJ"
	headers = ['X-Api-Key: '+str(api_key)]
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Set text_label of the label
func set_text_label(json):
	var out
	if json != null:
		out = "Airport: "
		out += json[0]["name"]
		out += "\nICAO: "
		out += json[0]["icao"]
		out += "\nIATA: "
		out += json[0]["iata"]
		out += "\nCountry: "
		out += json[0]["country"]
		out += "\nCity: "
		out += json[0]["city"]
		out += "\nElevation: "
		out += json[0]["elevation_ft"]
		out += " ft"
	else:
		out = "API Error"
	text_label.text_label = out
	
	
	Logger.write_to_log(name, "set_text_label()", out)
	Logger.write_to_console(name, "set_text_label()", out)


# On finished api request call set_text_label()
func _on_http_request_request_completed(result, response_code, headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())
	set_text_label(data)
	
	Logger.write_to_log(name, "pulled data from api", data)
	Logger.write_to_console(name, "pulled data from api", data)


# On button press initiate api request
func _on_pressed():
	HTTP_req.request_completed.connect(_on_http_request_request_completed)
	HTTP_req.request(api_link, headers)
	
	text_label.text_label = "Loading..."
	
	
	Logger.write_to_log(name, "httprequest")
	Logger.write_to_console(name, "httprequest")
