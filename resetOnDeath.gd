extends Area2D

func _ready():
	connect("body_entered", self, "onBodyEntered")

func onBodyEntered(body: Node) -> void:
	if !body.is_in_group("player"): return
	get_tree().reload_current_scene()
