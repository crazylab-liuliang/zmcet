extends TextureFrame

var dir = ""
var subdir = ""

func set(dir_, subdir_):
	self.dir = dir_
	self.subdir = subdir_
	
	# material
	var material = ResourceLoader.load("res://templates/unit/icon_hue.tres").duplicate()
	get_node("icon").set_material(material)
	
	# icon
	var icon_path = dir+ subdir + "/icon.png"
	var tex = ResourceLoader.load(icon_path)
	get_node("icon").set_normal_texture(tex)
	
	# text
	var unit_name = subdir
	var unit_text = unit_name
	
	var start_idx = unit_text.find(".")
	if start_idx > 0:
		start_idx = start_idx + 1
		var str_len = unit_text.length() - start_idx
		unit_text = unit_text.substr(start_idx, str_len)
		
	get_node("name").set_text(unit_text)
	
	# lesson
	update_hue()
	
func update_hue():
	var finishedRatio = finished_lessons_accuracy(dir+subdir)
	var lesson = String(int(finishedRatio*100)) + "%"
	get_node("progress").set_text(lesson)
	
	if finishedRatio > 0:
		set_hue( finishedRatio)
	else:
		set_hue(0.0)
	
func lesson_num(dir):
	return list_lessons(dir).size()
	
func finished_lessons_accuracy(dir):
	var total = 0
	var accuracy = 0
	var data_node = get_node("/root/data")
	for file in list_lessons(dir):
		var lesson_file = dir + "/" + file
		var fileHandle = File.new()
		var lesson_md5 = fileHandle.get_md5(lesson_file)
		accuracy += data_node.get_lesson_accuracy(lesson_md5)
		total += 100
	
	if total > 0:
		return accuracy / total
	else:
		return 0.0
	
func list_lessons(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not dir.current_is_dir() and not file.begins_with("."):
			if file.extension() == "lesson":
				files.append(file)
			
	dir.list_dir_end()
	return files

func _on_icon_pressed():
	if has_node("/root/launch"):
		get_node("/root/launch").on_unit_clicked(dir, subdir, self)
		
func set_hue(hue):
	get_node("icon").get_material().set_shader_param("Hue", hue)
