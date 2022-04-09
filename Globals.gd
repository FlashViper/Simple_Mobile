extends Node

enum {STATE_NORMAL, STATE_TRANSITION}
var state := STATE_NORMAL

var player : RigidBody2D
var playerAnim
var camera : Camera2D

# todo
var levels := PoolStringArray()

func _enter_tree() -> void:
#	levels = data.split("\n", false)
	var levelsRaw := Utility.loadFileLines("res://Levels/LevelOrder.txt")
	for l in levelsRaw:
		if l[0] != "#":
			levels.append(l)
	

func getLevelPath(index: int) -> String:
	if index > levels.size() - 1:
		return FALLBACK
	return "res://Levels/%s.tscn" % levels[SaveGame.levelIndex]

const FALLBACK := "res://GUI/you_won.tscn"
func nextLevel() -> void:
	SaveGame.levelIndex += 1
	state = STATE_TRANSITION
#	get_tree().change_scene("res://Levels/%s.tscn" % levels[levelIndex])
	TransitionManager.switchScene(getLevelPath(SaveGame.levelIndex))
	yield(TransitionManager, "finishedTransition")
	state = STATE_NORMAL

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_GO_BACK_REQUEST:
			TransitionManager.switchScene("res://GUI/TitleScreen.tscn")
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		TransitionManager.switchScene("res://GUI/TitleScreen.tscn")
