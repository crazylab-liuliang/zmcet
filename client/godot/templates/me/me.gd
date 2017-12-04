extends Control

func _ready():
	pass
	
func on_display():
	var exps = get_node("/root/data").get_exp()
	get_node("exp").set_text("Exp : " + String(int(exps)))
