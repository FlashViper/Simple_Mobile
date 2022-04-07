extends GridContainer

func _ready():
	for i in Globals.levels.size():
		var b := preload("res://GUI/LevelSelectButton.tscn").instance()
		add_child(b)
		b.text = str(i + 1)
		b.connect("pressed", self, "gotoLevel", [i])

func gotoLevel(index: int) -> void:
	Globals.levelIndex = index
	TransitionManager.switchScene("Levels/" + Globals.levels[index] + ".tscn")
