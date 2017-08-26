extends Node

var question_file = "res://data/test.blankedcloze.xml"
var question_data = {}
var content_now   = ""

func _ready():
	load_question()
	
	content_now = question_data.content
	for i in range(20):
		var orig_str = "(%d)" % i 
		var dest_str = "[color=red][url=%d](%d)[/url][/color]" % [i, i]
		content_now = content_now.replace(orig_str, dest_str)
	
	get_node("content").set_use_bbcode(true)
	get_node("content").append_bbcode(content_now)
	
func load_question():
	var file = File.new()
	file.open(question_file,File.READ)
	var json_str = file.get_as_text()
	question_data.parse_json(json_str) 

func _on_content_meta_clicked( meta):
	var i = int(meta)
	var orig_str = "[color=red][url=%d](%d)[/url][/color]" % [i, i]
	var dest_str = "[color=green][url=%d](Apple)[/url][/color]" % i
	content_now = content_now.replace(orig_str, dest_str)
	
	get_node("content").clear()
	get_node("content").append_bbcode(content_now)
