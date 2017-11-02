extends Control

var exercises = null
var exercise_data = {}
var is_answer_right = false

func set_data(data, exercises_):
	exercise_data = data
	exercises = exercises_
	
func _on_return_pressed():
	get_node("/root/launch").show("lessons")

func _on_continue_pressed():
	exercises.next_exercise(is_answer_right)
