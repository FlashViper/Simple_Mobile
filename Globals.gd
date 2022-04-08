extends Node

enum {STATE_NORMAL, STATE_TRANSITION}
var state := STATE_NORMAL

var player : RigidBody2D
var playerAnim
var camera : Camera2D

# todo
var levelIndex := 0
var levels := PoolStringArray()
#var data := """
#Level1
#Level2
#Level3
#Level4
#Level_Water_1
#Level_Water_2
#Level_Water_3
#Level_Water_4
#../Gameplay
#"""

func _enter_tree() -> void:
#	levels = data.split("\n", false)
	levels = Utility.loadFileLines("res://Levels/LevelOrder.txt")

var fallback := "res://GUI/TitleScreen.tscn"
func nextLevel() -> void:
	levelIndex += 1
	state = STATE_TRANSITION
	if levelIndex > levels.size() - 1:
		TransitionManager.switchScene(fallback)
		return
#	get_tree().change_scene("res://Levels/%s.tscn" % levels[levelIndex])
	TransitionManager.switchScene("res://Levels/%s.tscn" % levels[levelIndex])
	yield(TransitionManager, "finishedTransition")
	state = STATE_NORMAL

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_GO_BACK_REQUEST:
			TransitionManager.switchScene("res://GUI/TitleScreen.tscn")
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		TransitionManager.switchScene("res://GUI/TitleScreen.tscn")
