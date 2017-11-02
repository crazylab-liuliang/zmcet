extends Control

var exercises = null
var exercise_data = {}
var is_answer_right = false

func _ready():
	set_process(true)
	
func _process(delta):
	if exercises!=null and not is_hidden():
		if not OS.native_video_is_playing():
			exercises.next_exercise(true)

func set_data(data, exercises_):
	exercise_data = data
	exercises = exercises_
	
	OS.native_video_play(exercise_data.url, 1.0, "", "")
	
func _on_return_pressed():
	get_node("/root/launch").show("lessons")
