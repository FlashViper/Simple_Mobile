extends Node2D

onready var lThruster := $ThrusterParticlesL
onready var rThruster := $ThrusterParticlesR
onready var tween := $Tween

var taken := false
var squash := 1.0

func _ready() -> void:
	Globals.playerAnim = self
	
	if SaveGame.skin > 0:
		$Sprite.frame = SaveGame.skin

func _process(delta: float) -> void:
	squash = clamp(squash, 0, 2)
	scale = Vector2(squash, 2.0 - squash)

func animate(data) -> void:
	if taken:
		return
	rThruster.emitting = data.inputR > 0
	lThruster.emitting = data.inputL > 0
	squash = lerp(
		1.0,
		1.05,
		inverse_lerp(
			0,
			-150,
			data["linear_velocity"].y
		)
	)

# todo: different modes (cubic easing, bouncy easing
func interpolatePosition(globalPos: Vector2, time: float) -> void:
	rThruster.emitting = false
	lThruster.emitting = false
	
	tween.interpolate_property(self, "global_position", global_position, globalPos, 
		time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
