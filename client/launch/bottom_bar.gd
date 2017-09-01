extends TextureFrame

func _ready():
	pass

func _on_study_pressed():
	get_node("study").set_pressed(true)
	get_node("me").set_pressed(false)

func _on_me_pressed():
	get_node("study").set_pressed(false)
	get_node("me").set_pressed(true)
