extends Node2D

export var triggers := 1
var count := 0
var played : bool

#func _ready() -> void:
#	$ZoneTrigger.connect("area_entered", self, "onAreaEntered")

func activate() -> void:
	if played: return
	count += 1
	if count >= triggers:
		$AnimationPlayer.play("open")
		played = true
