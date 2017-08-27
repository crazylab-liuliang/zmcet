extends Control

export(String) var desc = ""

func _ready():
	get_node("desc").set_text(desc)
