extends Node

onready var viewport = get_viewport()

var minimum_size = Vector2(375, 667)

func _ready():
    viewport.connect("size_changed", self, "window_resize")
    window_resize()

func window_resize():
	var current_size = OS.get_window_size()
	
	var scale_factor = minimum_size.x/current_size.x
	var new_size = Vector2(minimum_size.x, current_size.y*scale_factor)
	
	viewport.set_size_override(true, new_size)
	print("viewport", new_size)