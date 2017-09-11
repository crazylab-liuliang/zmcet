extends Control

var exercises = null
var exercise_data = {}

func _ready():
	pass
	
func set_data(data, exercises_):
	exercise_data = data
	exercises = exercises_
	
	print(exercise_data)
	get_node("question").set_text(exercise_data.question)
	get_node("vbc/A").set_text(exercise_data.options.A)
	get_node("vbc/B").set_text(exercise_data.options.B)
	get_node("vbc/C").set_text(exercise_data.options.C)
	get_node("vbc/D").set_text(exercise_data.options.D)
	
	get_node("check").set_hidden(false)
	get_node("continue").set_hidden(true)
	
	get_node("hint_wrong").set_hidden(true)
	get_node("hint_correct").set_hidden(true)

func _on_return_pressed():
	get_node("/root/launch").show("lessons")

func _on_check_pressed():
	var answer = ""
	if get_node("vbc/A").is_pressed():
		answer += "A"
	if get_node("vbc/B").is_pressed():
		answer += "B"		
	if get_node("vbc/C").is_pressed():
		answer += "C"
	if get_node("vbc/D").is_pressed():
		answer += "D"

	if answer == exercise_data.answer:
		get_node("hint_correct/hint").set_text(exercise_data.hint)
		get_node("hint_correct").set_hidden(false)
	else:
		get_node("hint_wrong/hint").set_text(exercise_data.hint)
		get_node("hint_wrong").set_hidden(false)
		
	get_node("check").set_hidden(true)
	get_node("continue").set_hidden(false)


func _on_continue_pressed():
	exercises.next_exercise()
	
	get_node("vbc/A").set_pressed(false)
	get_node("vbc/B").set_pressed(false)
	get_node("vbc/C").set_pressed(false)
	get_node("vbc/D").set_pressed(false)
