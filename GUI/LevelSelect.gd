extends GridContainer

export (PoolColorArray) var colors := PoolColorArray()

func _ready():
	for i in Globals.levels.size():
		var b := preload("res://GUI/LevelSelectButton.tscn").instance()
		add_child(b)
		b.text = str(i + 1)
		b.connect("pressed", self, "gotoLevel", [i])
		
		var t := b.get_node("Indicator") as TextureRect
		var state := SaveGame.levelStates.get(i, 0) as int
		if state > 0:
			t.visible = true
			t.modulate = colors[state - 1]
		

func gotoLevel(index: int) -> void:
	SaveGame.levelIndex = index
	TransitionManager.switchScene("Levels/" + Globals.levels[index] + ".tscn")
