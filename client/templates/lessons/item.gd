extends Control

export(String) var name = ""
export(String) var desc = ""
export(String) var target_scene = ""

var lesson_file = ""
var lesson_data = {}
	
func set(dir, lesson):
	lesson_file = dir + lesson
	load_lesson()
	
	name = lesson_data.name
	desc = lesson_data.desc
	if lesson_data.type=="blankedcloze":
		target_scene = "res://templates/bankedcloze/BankedCloze.tscn"
	
	get_node("name").set_text(name)
	get_node("desc").set_text(desc)
	
func load_lesson():
	var file = File.new()
	file.open(lesson_file,File.READ)
	var json_str = file.get_as_text()
	lesson_data.parse_json(json_str) 

func _on_on_click_pressed():
	get_node("/root/launch").show("bankedcloze")
