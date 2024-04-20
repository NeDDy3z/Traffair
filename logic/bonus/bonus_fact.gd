extends Button



var api_link : String
var api_key : String

var HTTP_req : HTTPRequest
var text_label : Label
var headers 



# Called when the node enters the scene tree for the first time.
func _ready():
	## Initialize variables
	HTTP_req = HTTPRequest.new()
	text_label = $"../../../../text"
	api_link = "https://api.api-ninjas.com/v1/facts?limit=1"
	api_key = "hR1LjzS5Mqz+5L4x20wTJw==KzbXcGzzS6qKysoJ"
	headers = ['X-Api-Key: '+str(api_key)]
	
	## Add [HTTPRequest] Node to the tree
	add_child(HTTP_req)
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


## Set [value] to the [text_label.text]
func set_text_label(value):
	var out
	if (
		value != null 
		and not value.has("error")
	):
		out = "Fact:\n"
		out += str(value[0]["fact"])
	else:
		out = "API Error"
	text_label.text = out
	
	
	Logger.write_to_log(name, "set_text_label()", out)
	Logger.write_to_console(name, "set_text_label()", out)


## On GET request completed parse stringified-body to JSON and call [code]set_text_label[/code]
func _on_http_request_request_completed(_result, _response_code, _headers, body):
	var value 
	value = JSON.parse_string(body.get_string_from_utf8())
	set_text_label(value)
	
	
	Logger.write_to_log(name, "pulled data from api", value)
	Logger.write_to_console(name, "pulled data from api", value)


## On [Button] press intiate the HTTP GET Request and set the [text_label.text] a "Loading..." value
func _on_pressed():
	HTTP_req.request_completed.connect(_on_http_request_request_completed)
	HTTP_req.request(api_link, headers)
	
	text_label.text = "Loading..."
	
	
	Logger.write_to_log(name, "httprequest")
	Logger.write_to_console(name, "httprequest")
