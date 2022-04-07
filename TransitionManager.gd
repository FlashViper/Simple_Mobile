extends CanvasLayer

signal finishedTransition()

func transition(call : FuncRef, args := [], changeState := true) -> void:
	if changeState: Globals.state = Globals.STATE_TRANSITION
	$AnimationPlayer.play("Transition_Appear")
	yield($AnimationPlayer, "animation_finished")
	call.call_funcv(args)
	$AnimationPlayer.play("Transition_Disappear")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("finishedTransition")
	if changeState: Globals.state = Globals.STATE_NORMAL

func switchScene(scene: String) -> void:
	transition(funcref(get_tree(), "change_scene"), [scene])

func switchSceneTo(scene: PackedScene) -> void:
	transition(funcref(get_tree(), "change_scene_to"), [scene])

func reloadScene() -> void:
	transition(funcref(get_tree(), "reload_current_scene"))
