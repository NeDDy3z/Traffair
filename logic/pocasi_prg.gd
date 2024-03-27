extends Button


var api_link = "https://api.open-meteo.com/v1/forecast?latitude=50.088&longitude=14.4208&current=temperature_2m,apparent_temperature,precipitation&forecast_days=1"

var HTTP_req
var text_label
var log_gd = load("res://logic/log.gd")



# Called when the node enters the scene tree for the first time.
func _ready():
	HTTP_req = $HTTPRequest
	text_label = $"../../../text"


func set_text_label(json):
	var out
	if json != null:
		out = "Teplota: "
		out += str(json["current"]["temperature_2m"])
		out += " °C"
		
		out += "\nPocitová teplota: "
		out += str(json["current"]["apparent_temperature"])
		out += " °C"
		
		out += "\nPřeháňky: "
		out += str(json["current"]["precipitation"])
		out += " mm"
	else:
		out = "API Error"
	text_label.text = out


func _on_http_request_request_completed(result, response_code, headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())
	set_text_label(data)
	
	log_gd.write_to_log("weather", "pulled data from api", data)
	log_gd.write_to_console("weather", "pulled data from api", data)


func _on_pressed():
	HTTP_req.request_completed.connect(_on_http_request_request_completed)
	HTTP_req.request(api_link)
	
	text_label.text = "Loading..."
