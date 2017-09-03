extends TextureFrame

func set_icon(path):
	var tex = ResourceLoader.load(path)
	print(path)
	get_node("icon").set_texture(tex)
