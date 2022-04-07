extends Area2D

var following : bool
onready var root := position

func _ready():
	connect("body_entered", self, "onEnter")

func onEnter(body: PhysicsBody2D) -> void:
	if following or !body.is_in_group("player"): return
	following = true

func _process(delta: float) -> void:
	var pos = root
	if following:
		pos = Globals.player.position
		pos += (position - pos).normalized() * 40
		if Globals.player.get_colliding_bodies().size() > 0:
			following = false
	position = lerp(position, pos , 0.1)
