extends Control

func _ready():
	pass

func switchScene(sceneName: String) -> void:
	TransitionManager.switchScene("res://" + sceneName + ".tscn")

func quit() -> void:
	get_tree().quit()
