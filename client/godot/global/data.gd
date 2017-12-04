extends Node

var is_logined = false

var file_name = "user://data.dic"
var config_file = null

var finished_lessons_str = ""
var finished_lessons = {}

var catalogue_dict = {}

func _ready():
	config_file = ConfigFile.new()
	if config_file.load(file_name) == OK:
		finished_lessons_str = config_file.get_value("data", "finished_lessons", finished_lessons.to_json())
		finished_lessons.parse_json(finished_lessons_str)
	
	var dir = Directory.new()
	if dir.file_exists("res://courses/catalogue/catalogue.json"):
		var file = File.new()
		if file.open("res://courses/catalogue/catalogue.json", file.READ)==OK:
			var text = file.get_as_text()
			catalogue_dict.parse_json(text)
			print(catalogue_dict)
		file.close()

func select_course(course):
	config_file.set_value("data", "current_course", course)
	
	save()
	
func get_current_course():
	if catalogue_dict.has("default"):
		var default = catalogue_dict["default"]
		return config_file.get_value("data", "current_course", default)
	else:
		return config_file.get_value("data", "current_course", "cet4")

func on_learned_lesson(lesson, accuracy):
	var lesson_dict = {}
	lesson_dict["accuracy"] = accuracy
	finished_lessons[lesson] = lesson_dict	
		
	save()
	
func is_lesson_learned(lesson):
	if finished_lessons.has(lesson):
		return true
	else:
		return false
		
func get_lesson_accuracy(lesson_md5):
	if finished_lessons.has(lesson_md5):
		return finished_lessons[lesson_md5]["accuracy"]
	else:
		return 0
		
func get_exp():
	return 50.0 * finished_lessons.size()

func save():
	config_file.set_value("data", "finished_lessons", finished_lessons.to_json())
	config_file.save(file_name)
	