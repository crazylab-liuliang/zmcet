extends TextureFrame

var unit_idx = 0

func _ready():
	pass

func add_unit(dir):
	if unit_idx == 0:
		get_node("unit1").set_icon(dir+"icon.png")
		unit_idx +=1
		return true
	if unit_idx == 1:
		get_node("unit2").set_icon(dir+"icon.png")
		unit_idx +=1
		return true
	if unit_idx == 2:
		get_node("unit3").set_icon(dir+"icon.png")
		unit_idx +=1
		return true
	else:
		return false