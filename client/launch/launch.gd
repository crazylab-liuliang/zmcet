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
	
	var dir = cur_course.get_base_dir() + "/"
	
	# setting icon
	var course_icon = dir + "icon.png"
	get_node("ui/head_bar").set_course_icon(course_icon)
	
	#
	var dirs = list_subdirectorys_in_directory(dir)
	print(dirs)
	
	# show units
	var vcontainer = get_node("ui/body/VBoxContainer")
	var i = 0
	while i < dirs.size():	
		var rani = randi() % 3	
		var unit = null
		if rani == 0:
			unit = preload("res://templates/unit/units_column_1.tscn").instance()
		elif rani==1:	
			unit = preload("res://templates/unit/units_column_2.tscn").instance()
		else:
			unit = preload("res://templates/unit/units_column_3.tscn").instance()
			
		while i<dirs.size() and unit.add_unit(dir, dirs[i]):
			i+=1
			
		vcontainer.add_child(unit)
		
	var unit_bottom = preload("res://templates/unit/units_bottom.tscn").instance()
	vcontainer.add_child(unit_bottom)
	
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
			
	dir.list_dir_end()
	return files
	
func list_subdirectorys_in_directory(path):
	var dirs = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif dir.current_is_dir() and not file.begins_with("."):
			dirs.append(file)
			
	dir.list_dir_end()
	return dirs
	