extends Control

func _ready():
	pass
	
func set_course_icon(texPath):
	var texRes = ResourceLoader.load(texPath)
	texRes.set_size_override(Vector2(127,127))
	get_node("corner_bg/course").set_normal_texture(texRes)