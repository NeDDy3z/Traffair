extends Button



var api_link : String = "www.google.com"

var HTTP_req
var text_label



# Called when the node enters the scene tree for the first time.
func _ready():
	HTTP_req = $HTTPRequest
	text_label = $"../../../text"


func set_text_label(json):
	var out
	if json != null:
		out = "Not implemented yet"
	else:
		out = "API Error"
	text_label.text = "Not implemented yet"


func _on_http_request_request_completed(result, response_code, headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())
	set_text_label(data)
	
	Logger.write_to_log("weather", "pulled data from api", data)
	Logger.write_to_console("weather", "pulled data from api", data)


func _on_pressed():
	HTTP_req.request_completed.connect(_on_http_request_request_completed)
	HTTP_req.request(api_link)
	
	text_label.text = "Loading..."
