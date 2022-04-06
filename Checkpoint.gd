extends Area2D
#const fallback := "res://Gameplay.tscn"

export var xRange := 5.0
onready var anim := $Visual/AnimationPlayer
#export var nextScene : PackedScene
var opened : bool
var triggered : bool

func _process(delta: float) -> void:
	if triggered:
		return
	var isOpened = false
	for b in get_overlapping_bodies():
		if b.is_in_group("player"):
			isOpened = true
			break
	if opened != isOpened:
		anim.play("Open" if isOpened else "Close")
	opened = isOpened
	
	if opened and !triggered:
		var player := Globals.player # for readability
		var flags : int
		flags += int(abs(player.position.x - $TargetPos.global_position.x) > xRange)
		flags += int(player.transform.y.dot(transform.y) < 0.8) * 2
		flags += int(player.linear_velocity.length_squared() > 10) * 4
		flags += int(player.angular_velocity > 1) * 16
		print(abs(player.position.x - $TargetPos.global_position.x) > xRange)
		if flags == 0:
			triggered = true
			anim.play("Close")
			Globals.playerAnim.interpolatePosition($PuppetPos.global_position, 0.45)
			yield(get_tree().create_timer(0.75), "timeout")
			Globals.nextLevel()
#			if nextScene:
#				get_tree().change_scene_to(nextScene)
#			else:
#				get_tree().change_scene(fallback)
