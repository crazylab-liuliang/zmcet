extends Control

var install_dir = "res://install/"
var courses_dir = "user://courses/"

func _ready():
	pass
	
func run():
	if first_run():
		set_default_course()
	
	# 设置默认课程
	var current_course = get_node("/root/data").get_current_course()
	if current_course==null:
		set_default_course()

	# 启动当前课程
	current_course = get_node("/root/data").get_current_course()
	if current_course != null:
		mount_course(current_course)
		
		var files = list_files_in_directory("res://courses/" + current_course + "/")
		
		get_node("/root/launch").set_course("res://courses/" + current_course + "/")
		
func mount_course(course_name):
	var dir = Directory.new()
	if not dir.dir_exists("res://courses/" + course_name + "/"):
		Globals.load_resource_pack(courses_dir + course_name + ".pck")

# 运行更新
func first_run():
	if !is_courses_exist_in_user_dir():
		# 检测是否自带安装包
		if is_have_installer():
			return install()
			
	return false
	
func set_default_course():
	var files = list_files_in_directory(courses_dir)
	for file in files:
		if file.extension()=="pck" and file!="catalogue.pck":
			get_node("/root/data").select_course(file.basename())
	
func is_courses_exist_in_user_dir():
	var dir = Directory.new()
	if dir.file_exists("user://courses/version.meta"):
		return true
	else:
		return false
		
func is_have_installer():
	var dir = Directory.new()
	if dir.file_exists("res://install/version.meta"):
		return true
	else:
		return false
		
func install():
	# clear
	create_dir("user://courses/")
	
	# copy version.meta
	var files = list_files_in_directory(install_dir)
	for file in files:
		print(file)
		var dir = Directory.new()
		if dir.copy(install_dir + file, courses_dir + file) != OK:
			print("copy version.meta failed")
			return false
	
	return true
	
func create_dir(dir):
	var directory = Directory.new()
	if !directory.file_exists(dir):
		directory.make_dir(dir)
		
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