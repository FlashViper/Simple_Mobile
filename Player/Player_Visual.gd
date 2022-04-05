extends Node2D

onready var lThruster := $ThrusterParticlesL
onready var rThruster := $ThrusterParticlesR
onready var tween := $Tween

var taken := false

func _ready() -> void:
	Globals.playerAnim = self

func animate(data: Dictionary) -> void:
	if taken:
		return
	(rThruster if data.invertDirections else lThruster).emitting = data.inputR > 0
	(lThruster if data.invertDirections else rThruster).emitting = data.inputL > 0

# todo: different modes (cubic easing, bouncy easing
func interpolatePosition(globalPos: Vector2, time: float) -> void:
	rThruster.emitting = false
	lThruster.emitting = false
	
	tween.interpolate_property(self, "global_position", global_position, globalPos, 
		time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
