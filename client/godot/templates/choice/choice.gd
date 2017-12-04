extends Control

var exercises = null
var exercise_data = {}
var node_vbc = null
var is_answer_right = false

func _ready():
	pass
	
func set_data(data, exercises_):
	exercise_data = data
	exercises = exercises_
	
	get_node("question").set_text(exercise_data.question)
	
	if exercise_data.answer.length() == 1:
		node_vbc = get_node("vbc_s")
		get_node("vbc_s").set_hidden(false)
		get_node("vbc_m").set_hidden(true)
	else:
		node_vbc = get_node("vbc_m")
		get_node("vbc_s").set_hidden(true)
		get_node("vbc_m").set_hidden(false)
	
	node_vbc.get_node("A/text").set_text("\t" + exercise_data.options.A)
	node_vbc.get_node("B/text").set_text("\t" +exercise_data.options.B)
	node_vbc.get_node("C/text").set_text("\t" +exercise_data.options.C)
	node_vbc.get_node("D/text").set_text("\t" +exercise_data.options.D)

	get_node("check").set_hidden(false)
	get_node("check").set_disabled(true)
	get_node("continue").set_hidden(true)
	
	get_node("hint_wrong").set_hidden(true)
	get_node("hint_correct").set_hidden(true)

func _on_return_pressed():
	get_node("/root/launch").show("lessons")

func _on_check_pressed():
	var answer = ""
	if node_vbc.get_node("A").is_pressed():
		answer += "A"
	if node_vbc.get_node("B").is_pressed():
		answer += "B"		
	if node_vbc.get_node("C").is_pressed():
		answer += "C"
	if node_vbc.get_node("D").is_pressed():
		answer += "D"

	if answer == exercise_data.answer:
		is_answer_right = true
		get_node("hint_correct/hint").set_bbcode(exercise_data.hint)
		get_node("hint_correct").set_hidden(false)
		get_node("sound").play("correct")
	else:
		is_answer_right = false
		get_node("hint_wrong/hint").set_bbcode(exercise_data.hint)
		get_node("hint_wrong").set_hidden(false)
		get_node("sound").play("wrong")
		
	get_node("check").set_hidden(true)
	get_node("continue").set_hidden(false)


func _on_continue_pressed():
	exercises.next_exercise(is_answer_right)
	
	node_vbc.get_node("A").set_pressed(false)
	node_vbc.get_node("B").set_pressed(false)
	node_vbc.get_node("C").set_pressed(false)
	node_vbc.get_node("D").set_pressed(false)
	

func _on_choice_toggled( pressed ):
	if node_vbc.get_node("A").is_pressed() or node_vbc.get_node("B").is_pressed() or node_vbc.get_node("C").is_pressed() or node_vbc.get_node("D").is_pressed():
		get_node("check").set_disabled(false)
	else:
		get_node("check").set_disabled(true)
