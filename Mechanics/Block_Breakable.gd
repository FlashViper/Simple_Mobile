extends RigidBody2D

export var useHealth : bool
export var maxHealth := 200
export var velocityThreshold := 180

onready var health := maxHealth
var tCooldown : float
var isDestroyed : bool

func _process(delta: float) -> void:
	if tCooldown > 0: tCooldown -= delta

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if isDestroyed or tCooldown > 0: return
	var count := state.get_contact_count()
	if count < 1: return
	for i in count:
		var c := state.get_contact_collider_object(i)
		if !c.is_in_group("player"): continue
		var v := Globals.player.linear_velocity
		var n := transform.basis_xform_inv(state.get_contact_local_normal(i))
		
		var dmg := max(int(v.dot(n)), 0)
		print(dmg, " ", v.length())
		if dmg > velocityThreshold:
			destroy()
		elif useHealth:
			damage(dmg)
		else:
			damage(0)


func damage(amnt: int) -> void:
	health -= amnt
	if health < 1:
		destroy()
	else:
		tCooldown = 0.25
		$AnimationPlayer.play("Damage")

func destroy() -> void:
	isDestroyed = true
	$AnimationPlayer.play("Dead")
