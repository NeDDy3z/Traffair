extends Button



var country_code : String
var year : String

var api_link : String
var api_key : String

var HTTP_req : HTTPRequest
var text_label : Label
var headers 



# Called when the node enters the scene tree for the first time.
func _ready():
	HTTP_req = $HTTPRequest
	text_label = $"../../../text"
	
	country_code = "CZ"
	year = str(Time.get_date_dict_from_system()["year"])
	
	api_link = "https://api.api-ninjas.com/v1/holidays?country="+ country_code +"&year="+year
	api_key = "hR1LjzS5Mqz+5L4x20wTJw==KzbXcGzzS6qKysoJ"
	headers = ['X-Api-Key: '+str(api_key)]
	
	
	Logger.write_to_log(name, "loaded")
	Logger.write_to_console(name, "loaded")


# Set text of the label
func set_text_label(json):
	var out
	var holidays : bool
	holidays = false
	
	if json != null:
		for item in json:
			if item["date"] == str(Time.get_date_string_from_system()):
				out = "Name: "
				out += item["name"]
				out += "\nType: "
				out += item["type"].to_lower().capitalize()
				holidays = true
		if !holidays:
			text_label.text = "Today's not a holiday"
	else:
		out = "API Error"
		text_label.text = out
		
		
	Logger.write_to_log(name, "set_text_label()", out)
	Logger.write_to_console(name, "set_text_label()", out)


# On finished api request call set_text_label()
func _on_http_request_request_completed(result, response_code, headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())
	set_text_label(data)
	
	Logger.write_to_log(name, "pulled data from api")
	Logger.write_to_console(name, "pulled data from api")


# On button press initiate api request
func _on_pressed():
	HTTP_req.request_completed.connect(_on_http_request_request_completed)
	HTTP_req.request(api_link, headers)
	
	text_label.text = "Loading..."
	
	
	Logger.write_to_log(name, "httprequest")
	Logger.write_to_console(name, "httprequest")
