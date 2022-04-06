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

func nextLevel() -> void:
	state = STATE_TRANSITION
	levelIndex = min(levelIndex + 1, levels.size() - 1)
	get_tree().change_scene("res://Levels/%s.tscn" % levels[levelIndex])
	yield(get_tree(), "tree_changed")
	state = STATE_NORMAL
