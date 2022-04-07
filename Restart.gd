extends Control

func _ready():
	$RestartButton.connect("pressed", self, "onReset")
	Globals.player.connect("stuck", self, "onPlayerStuck")

func onPlayerStuck(isStuck: bool) -> void:
	$AnimationPlayer.play("Appear" if isStuck else "Disappear")

func onReset() -> void:
	TransitionManager.reloadScene()
