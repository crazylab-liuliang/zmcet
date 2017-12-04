extends Control
	
func set(dir, subdir, unit):
	# set title
	get_node("title").set_text(subdir)
	
	# set icon
	var icon_path = dir + subdir + "/icon.png"
	var icon_tex = ResourceLoader.load(icon_path)
	get_node("bg/icon").set_texture(icon_tex)
	
	# show lessons info
	for child in get_node("body/VBoxContainer").get_children():
		child.queue_free()
	
	var lessons = get_node("/root/global").list_lessons(dir + subdir)
	for lesson in lessons:
		var lesson_item = load("res://templates/lessons/item.tscn").instance()
		get_node("body/VBoxContainer").add_child(lesson_item)
		lesson_item.set(dir+subdir+"/", lesson, unit)

func _on_return_pressed():
	get_node("/root/launch").show("main")
# 
