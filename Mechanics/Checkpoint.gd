extends Area2D
#const fallback := "res://Gameplay.tscn"

export var xRange := 5.0
onready var anim := $Visual/AnimationPlayer
#export var nextScene : PackedScene
var opened : bool
var triggered : bool

var i_hasTouchedGround : bool
var i_hasTouchedWall : bool
var hasTouchedGround : bool
var hasTouchedWall : bool

var tTimeSinceTouchedGround : float
var tTimeSinceTouchedWall : float

var trigger := false

func _ready() -> void: 
	yield(get_tree().create_timer(0.15), "timeout")
	trigger = true

func _process(delta: float) -> void:
#	print(Globals.player.onWall)
	if !trigger or !Globals.player: return
	if Globals.player.onWall:
		if !hasTouchedWall and i_hasTouchedWall:
			hasTouchedWall = true
			tTimeSinceTouchedWall = 0.65
	else:
		i_hasTouchedWall = true
		
	if Globals.player.onGround:
		if !hasTouchedGround and i_hasTouchedGround:
			hasTouchedGround = true
			tTimeSinceTouchedGround = 0.65
	else:
		i_hasTouchedGround = true
	
	tTimeSinceTouchedGround -= delta
	tTimeSinceTouchedWall -= delta
	
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
		var flags := 0
		flags += int(abs(player.global_position.x - $TargetPos.global_position.x) > xRange)
		flags += int(abs(player.transform.y.dot(transform.y)) < 0.8) * 2
		flags += int(player.linear_velocity.length_squared() > 10) * 4
		flags += int(player.angular_velocity > 1) * 16
		flags += int(!player.onWall)
#		print(abs(player.position.x - $TargetPos.global_position.x) > xRange)
		if flags == 0:
			triggered = true
			var level := (2 if !hasTouchedWall or tTimeSinceTouchedWall > 0  
				else 1 if !hasTouchedGround or tTimeSinceTouchedGround > 0 
				else 0)
			SaveGame.levelStates[SaveGame.levelIndex] = max(level, SaveGame.levelStates.get(SaveGame.levelIndex, 0))
#			print(level)
#			print({
#				"wall": hasTouchedWall,
#				"tWall": tTimeSinceTouchedWall,
#				"ground": hasTouchedGround,
#				"tGround": tTimeSinceTouchedGround,
#			})
			if level > 0:
				TransitionManager.anim.play("Flash")
				match level:
					1: $Visual/Particles/silver.emitting = true
					2: $Visual/Particles/gold.emitting = true
				var state := 2
				for i in Globals.levels.size():
					var s :int= SaveGame.levelStates.get(i, 0)
					if s < 2:
						if s < 1:
							state = 0
							break
						else:
							state = 1
				match state:
					1:
						if !SaveGame.isSkinUnlocked(12):
							SaveGame.skinsUnlocked.append(12)
					2:
						if !SaveGame.isSkinUnlocked(13):
							SaveGame.skinsUnlocked.append(13)
			
			anim.play("Close")
			Globals.playerAnim.interpolatePosition($PuppetPos.global_position, 0.45)
			yield(get_tree().create_timer(0.75), "timeout")
			Globals.nextLevel()
			SaveGame.saveState()
#			if nextScene:
#				get_tree().change_scene_to(nextScene)
#			else:
#				get_tree().change_scene(fallback)
