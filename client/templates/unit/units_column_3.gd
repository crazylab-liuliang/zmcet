extends TextureFrame

var unit_idx = 0

func _ready():
	pass

func add_unit(dir, subdir):
	if unit_idx == 0:
		get_node("unit1").set(dir, subdir)
		unit_idx +=1
		return true
	if unit_idx == 1:
		get_node("unit2").set(dir, subdir)
		unit_idx +=1
		return true
	if unit_idx == 2:
		get_node("unit3").set(dir, subdir)
		unit_idx +=1
		return true
	else:
		return false