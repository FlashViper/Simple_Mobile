extends Button

export (PackedScene) var scene := preload("res://GUI/TitleScreen.tscn") as PackedScene

func _ready():
	connect("pressed", self, "onPressed")

func onPressed() -> void:
	TransitionManager.switchSceneTo(scene)
