extends TextureFrame

var dir = ""
var subdir = ""

func set(dir_, subdir_):
	self.dir = dir_
	self.subdir = subdir_
	
	# icon
	var icon_path = dir+ subdir + "/icon.png"
	var tex = ResourceLoader.load(icon_path)
	get_node("icon").set_normal_texture(tex)
	
	# text
	var unit_name = subdir
	get_node("name").set_text(unit_name)
	
	# lesson
	var finish_lessons = 1
	var lesson_nums = lesson_num(dir+subdir)
	var lesson = String(finish_lessons) + "/" + String(lesson_nums)
	get_node("progress").set_text(lesson)
	
	if lesson_nums > 0:
		set_hue( finish_lessons/lesson_nums)
	else:
		set_hue(0.0)
	
func lesson_num(dir):
	return list_lessons(dir).size()
	
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
		get_node("/root/launch").on_unit_clicked(dir, subdir)
		
func set_hue(hue):
	get_node("icon").get_material().set_shader_param("Hue", hue)
