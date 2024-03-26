extends Button


var api_link = "https://svatky.adresa.info/txt"
var date

var HTTP_req
var text_label
var log_gd = load("res://logic/log.gd")



# Called when the node enters the scene tree for the first time.
func _ready():
	HTTP_req = $HTTPRequest
	text_label = $"../../../text"
	
	date = Time.get_date_string_from_system()


func set_text_label(data):
	var out
	if data != null:
		out = "Datum: "
		out += date
		
		out += "\nJméno: "
		out += str(data.split(";")[1])
	else:
		out = "API Error"
	text_label.text = out


func _on_http_request_request_completed(result, response_code, headers, body):
	var data = body.get_string_from_utf8()
	set_text_label(data)


func _on_pressed():
	HTTP_req.request_completed.connect(_on_http_request_request_completed)
	HTTP_req.request(api_link)
	
	text_label.text = "Loading..."
