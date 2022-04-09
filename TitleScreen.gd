extends Control

func _ready():
	pass

func switchScene(sceneName: String) -> void:
	TransitionManager.switchScene("res://" + sceneName + ".tscn")

func switchLevel(index: int) -> void:
	SaveGame.levelIndex = index
	TransitionManager.switchScene(Globals.getLevelPath(index))

func quit() -> void:
	get_tree().quit()


func currentLevel() -> void:
	TransitionManager.switchScene(Globals.getLevelPath(SaveGame.levelIndex))
