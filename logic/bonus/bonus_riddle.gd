extends Button



var api_link : String
var api_key : String

var HTTP_req : HTTPRequest
var text_label : Label
var headers 



# Called when the node enters the scene tree for the first time.
func _ready():
	HTTP_req = $HTTPRequest
	text_label = $"../../../text"
	
	api_link = "https://api.api-ninjas.com/v1/riddles"
	api_key = "hR1LjzS5Mqz+5L4x20wTJw==KzbXcGzzS6qKysoJ"
	headers = ['X-Api-Key: '+str(api_key)]
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Set text of the label
func set_text_label(json):
	var out
	if json != null:
		out = "Title:\n"
		out += str(json[0]["title"])
		
		out += "\n\nQuestion:\n"
		out += str(json[0]["question"])
		
		out += "\n\nAnswer:\n"
		out += str(json[0]["answer"])
	else:
		out = "API Error"
	text_label.text = out
	
	
	Logger.write_to_log(name, "set_text_label()", out)
	Logger.write_to_console(name, "set_text_label()", out)


# On finished api request call set_text_label()
func _on_http_request_request_completed(_result, _response_code, _headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())
	set_text_label(data)
	
	
	Logger.write_to_log(name, "pulled data from api", data)
	Logger.write_to_console(name, "pulled data from api", data)


# On button press initiate api request
func _on_pressed():
	HTTP_req.request_completed.connect(_on_http_request_request_completed)
	HTTP_req.request(api_link, headers)
	text_label.text = "Loading..."
	
	
	Logger.write_to_log(name, "httprequest")
	Logger.write_to_console(name, "httprequest")
