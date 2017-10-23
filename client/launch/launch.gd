extends Node

var cur_course = ""

func _ready():
	set_process(true)
	
func _process(delta):
	if !has_node("/root/global"):
		var global = load("res://global/global.gd").new()
		global.set_name("global")
		get_tree().get_root().add_child(global)
		
		var dir = Directory.new()
		if not dir.file_exists("res://courses/catalogue/catalogue.json"):
			set_course("res://courses_example/example/")
		else:
			var current_course = get_node("/root/data").get_current_course()	
			set_course("res://courses/" + current_course + "/")
		
func set_course(course):
	cur_course = course;
	
	var dir = cur_course.get_base_dir() + "/"
	
	# setting icon
	var course_icon = dir + "icon.png"
	
	get_node("ui/main/head_bar").set_course_icon(course_icon)
	#
	var dirs = list_subdirectorys_in_directory(dir)
	print(dirs)
	
	# show units
	var vcontainer = get_node("ui/main/body/VBoxContainer")
	var i = 0
	while i < dirs.size():
		var rani = min(randi() % 3, dirs.size()-i-1)
		var unit = null
		if rani == 0:
			unit = preload("res://templates/unit/units_column_1.tscn").instance()
		elif rani==1:	
			unit = preload("res://templates/unit/units_column_2.tscn").instance()
		else:
			unit = preload("res://templates/unit/units_column_3.tscn").instance()
		
		vcontainer.add_child(unit)
		while i<dirs.size() and unit.add_unit(dir, dirs[i]):
			i+=1
		
	var unit_bottom = preload("res://templates/unit/units_bottom.tscn").instance()
	vcontainer.add_child(unit_bottom)
	
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	if dir.open(path)!=OK:
		return files
	
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
	
func on_unit_clicked(dir, subdir, unit):
	get_node("ui/lessons").set(dir, subdir, unit)
	show("lessons")
	
func show(type):
	get_node("ui/main").set_hidden(true)
	get_node("ui/me").set_hidden(true)
	get_node("ui/lessons").set_hidden(true)
	#get_node("ui/bankedcloze").set_hidden(true)
	get_node("ui/choice").set_hidden(true)
	get_node("ui/bottom_bar").set_hidden(true)
	
	if type=="main":
		get_node("ui/main").set_hidden(false)
		get_node("ui/bottom_bar").set_hidden(false)
	if type=="lessons":
		get_node("ui/lessons").set_hidden(false)
	#if type=="bankedcloze":
	#	get_node("ui/bankedcloze").set_hidden(false)
	if type=="me":
		get_node("ui/me").set_hidden(false)
		get_node("ui/me").on_display()
		get_node("ui/bottom_bar").set_hidden(false)	
	if type=="choice":
		get_node("ui/choice").set_hidden(false)
		