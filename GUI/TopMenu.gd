extends ToolButton

var t : float

func _ready():
	for c in get_children(): c.visible = false
	connect("pressed", self, "onPressed")

func onPressed() -> void:
	for c in get_children(): c.visible = true
	t = 1.5

func _process(delta: float) -> void:
	if t > 0:
		t -= delta
		if t <= 0: for c in get_children(): c.visible = false
		return
