extends NinePatchRect

export var sideMargin := 3
export var topMargin := 15

func _ready():
	var targetRect := Rect2(Vector2(), rect_size).grow_individual(
		-sideMargin, -topMargin, -sideMargin, 0)
	
	var c := CollisionShape2D.new()
	var s := RectangleShape2D.new()
	s.extents = targetRect.size * 0.5
	c.shape = s
	c.position = targetRect.position + targetRect.size * 0.5
	$trigger.add_child(c)
