extends Control

export(String) var name = ""
export(String) var desc = ""
export(String) var target_scene = ""

func _ready():
	get_node("name").set_text(name)
	get_node("desc").set_text(desc)

func _on_on_click_pressed():
	get_node("/root/global").set_scene(target_scene)
