extends Control

export(String) var name = ""
export(String) var desc = ""

var lesson_file = ""
var lesson_data = {}
var exercise_num = 0
var current_exercise = 0
	
func set(dir, lesson):
	lesson_file = dir + lesson
	load_lesson()
	
	name = lesson_data.title
	desc = lesson_data.desc	
	get_node("name").set_text(name)
	get_node("desc").set_text(desc)
	
	exercise_num = lesson_data.exercise_num.to_int()
	
func load_lesson():
	var file = File.new()
	file.open(lesson_file,File.READ)
	var json_str = file.get_as_text()
	lesson_data.parse_json(json_str) 

func _on_on_click_pressed():
	current_exercise = 0
	show_exercise()
			
func next_exercise():
	current_exercise += 1
	show_exercise()
	
func show_exercise():
	if current_exercise >= 0 && current_exercise<exercise_num:
		var exercise_data = lesson_data["exercise_" + String(current_exercise)]
		var type = exercise_data.type
		if type=="choice":
			get_node("/root/launch/ui/choice").set_data(exercise_data, self)
			get_node("/root/launch").show("choice")
	else:
		get_node("/root/launch").show("lessons")
