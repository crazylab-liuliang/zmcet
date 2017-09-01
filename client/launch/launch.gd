extends Node

var cur_course = ""

func _ready():
	set_process(true)
	set_course("res://data/cet4/cet4.course")
	
func _process(delta):
	if !has_node("/root/global"):
		var global = load("res://global/global.gd").new()
		global.set_name("global")
		get_tree().get_root().add_child(global)
		
		
func set_course(course):
	cur_course = course;
	
	var dir = cur_course.get_base_dir()
	
	# 
	var course_icon = dir + "/icon.png"
	get_node("ui/head_bar").set_course_icon(course_icon)
	
	