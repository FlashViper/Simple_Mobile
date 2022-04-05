extends ReferenceRect

func _ready():
	var c := Globals.camera
	c.limit_left = rect_global_position.x
	c.limit_top = rect_global_position.y
	c.limit_right = rect_global_position.x + rect_size.x
	c.limit_bottom = rect_global_position.y + rect_size.y
