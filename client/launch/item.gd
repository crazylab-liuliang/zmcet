extends Control

export(String) var target_scene = ""

func _ready():
	pass

func _on_on_click_pressed():
	get_node("/root/global").set_scene(target_scene)
	pass
