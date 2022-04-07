extends Area2D

signal onCollected()

export var disableOnGround := true
var following : bool
onready var root := position
var doors : Array
var collected : bool

func _ready():
	connect("body_entered", self, "onEnter")
	var _doors := get_tree().get_nodes_in_group("door")
	for _d in _doors:
		doors.append(_d.get_node("TriggerZone"))

func onEnter(body: PhysicsBody2D) -> void:
	if !body or following or collected or !body.is_in_group("player"): return
	following = true

func _process(delta: float) -> void:
	if collected: return
	
	var pos = root
	if following:
		pos = Globals.player.global_position
		pos += (global_position - pos).normalized() * 40
		for d in doors:
			if d.get_global_rect().has_point(pos):
				collect(d)
				return
		
		if disableOnGround && Globals.player.onGround:
			following = false
	global_position = lerp(global_position, pos , 0.1)

func collect(obj: Node):
	collected = true
	var t := Tween.new()
	add_child(t)
	
	t.interpolate_property(self, "global_position", 
		global_position, obj.get_parent().global_position, 0.5,
		Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	t.start()
	yield(t, "tween_all_completed")
	print(t)
	
	obj.get_parent().activate()
	emit_signal("onCollected")
	queue_free()
