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
	
	# setting icon
	var course_icon = dir + "/icon.png"
	get_node("ui/head_bar").set_course_icon(course_icon)
	
	# show units
	var vcontainer = get_node("ui/body/VBoxContainer")
	for i in range(5):
		var rani = randi() % 3	
		var unit = null
		if rani == 0:
			unit = preload("res://templates/unit/units_column_1.tscn").instance()
		elif rani==1:	
			unit = preload("res://templates/unit/units_column_2.tscn").instance()
		else:
			unit = preload("res://templates/unit/units_column_3.tscn").instance()
			
		vcontainer.add_child(unit)
	
	