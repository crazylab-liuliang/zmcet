extends TextureFrame

func _ready():
	pass

func _on_study_pressed():
	get_node("study").set_pressed(true)
	get_node("study/text").set("custom_colors/font_color", Color(0.29,0.565,0.886))
	get_node("me").set_pressed(false)
	get_node("me/text").set("custom_colors/font_color", Color(0.592,0.592,0.592))
	
	get_node("/root/launch").show("main")

func _on_me_pressed():
	get_node("study").set_pressed(false)
	get_node("study/text").set("custom_colors/font_color", Color(0.592,0.592,0.592))
	get_node("me").set_pressed(true)
	get_node("me/text").set("custom_colors/font_color", Color(0.29,0.565,0.886))

	get_node("/root/launch").show("me")