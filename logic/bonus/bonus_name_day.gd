extends Button



var api_link : String
var date : String

var HTTP_req : HTTPRequest
var text_label : Label



# Called when the node enters the scene tree for the first time.
func _ready():
	## Initialize variables
	HTTP_req = HTTPRequest.new()
	text_label = $"../../../../text"
	api_link = "https://svatky.adresa.info/txt"
	date = Time.get_date_string_from_system()
	
	## Add [HTTPRequest] Node to the tree
	add_child(HTTP_req)
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


## Set [value] to the [text_label.text]
func set_text_label(value):
	var out
	if (
		value != null 
		and not value.contains("error")
	):
		out = "Date: "
		out += date
		
		out += "\nName: "
		out += str(value.split(";")[1])
	else:
		out = "API Error"
	text_label.text = out
	
	
	Logger.write_to_log(name, "set_text_label()", out)
	Logger.write_to_console(name, "set_text_label()", out)


## On GET request completed parse stringified-body to JSON and call [code]set_text_label[/code]
func _on_http_request_request_completed(_result, _response_code, _headers, body):
	var value 
	value = body.get_string_from_utf8()
	set_text_label(value)
	
	
	Logger.write_to_log(name, "pulled data from api", value)
	Logger.write_to_console(name, "pulled data from api", value)


## On [Button] press intiate the HTTP GET Request and set the [text_label.text] a "Loading..." value
func _on_pressed():
	HTTP_req.request_completed.connect(_on_http_request_request_completed)
	HTTP_req.request(api_link)
	text_label.text = "Loading..."
	
	
	Logger.write_to_log(name, "httprequest")
	Logger.write_to_console(name, "httprequest")
