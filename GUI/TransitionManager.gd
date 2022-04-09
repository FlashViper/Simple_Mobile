extends CanvasLayer

signal finishedTransition()
onready var anim: AnimationPlayer = $AnimationPlayer

func transition(call : FuncRef, args := [], changeState := true) -> void:
#	if changeState: Globals.state = Globals.STATE_TRANSITION
	anim.play("Transition_Appear")
	yield(anim, "animation_finished")
	call.call_funcv(args)
	anim.play("Transition_Disappear")
	yield(anim, "animation_finished")
	emit_signal("finishedTransition")
#	if changeState: Globals.state = Globals.STATE_NORMAL

func switchScene(scene: String) -> void:
	transition(funcref(get_tree(), "change_scene"), [scene], true)

func switchSceneTo(scene: PackedScene) -> void:
	transition(funcref(get_tree(), "change_scene_to"), [scene], true)

func reloadScene() -> void:
	transition(funcref(get_tree(), "reload_current_scene"), [], true)
