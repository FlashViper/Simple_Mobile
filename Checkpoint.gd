extends Area2D
const fallback := "res://Gameplay.tscn"

export var xRange := 5.0
onready var anim := $Visual/AnimationPlayer
export var nextScene : PackedScene
var opened : bool

func _process(delta: float) -> void:
	var isOpened = false
	for b in get_overlapping_bodies():
		if b.is_in_group("player"):
			isOpened = true
			break
	if opened != isOpened:
		anim.play("Open" if isOpened else "Close")
	opened = isOpened
	
	if opened:
		var player := Globals.player # for readability
		var flags : int
		flags += int(abs(player.position.x - $TargetPos.global_position.x) > xRange)
		flags += int(player.transform.y.dot(transform.y) < 0.8)
		flags += int(player.linear_velocity.length_squared() > 10)
		flags += int(player.angular_velocity > 1)
		if flags == 0:
			Globals.playerAnim.interpolatePosition($PuppetPos.global_position, 0.25)
			yield(get_tree().create_timer(0.5), "timeout")
			if nextScene:
				get_tree().change_scene_to(nextScene)
			else:
				get_tree().change_scene(fallback)
