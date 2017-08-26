extends Node

var question_file = "res://data/test.blankedcloze.xml"
var question_data = {}

func _ready():
	load_question()
	get_node("content").set_text(question_data.content)
	
func load_question():
	var file = File.new()
	file.open(question_file,File.READ)
	var json_str = file.get_as_text()
	question_data.parse_json(json_str) 