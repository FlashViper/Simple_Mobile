extends RigidBody2D

signal stuck(isStuck)

export var thrusterForce := 10
export var thrusterOffsetX := 13
export var maxSpeedY := 50

onready var rDir := Vector2(-thrusterOffsetX , 0)#20)
onready var lDir := Vector2(thrusterOffsetX, 0)#20)

var inputR : float
var inputL : float
var invertDirections := false

var stuck : bool

func _ready() -> void:
	Globals.player = self

func _process(delta: float) -> void:
	$Visual.animate(inst2dict(self))

#todo: analize for frame-dependance
func _physics_process(delta: float) -> void:
	pollInput()
#	applied_force = Vector2.ZERO
	apply_impulse((rDir).rotated(rotation)* inputR, -transform.y * thrusterForce * inputR * delta)
	apply_impulse((lDir).rotated(rotation)* inputL, -transform.y * thrusterForce * inputL * delta)
	
	if linear_velocity.y > -8 and linear_velocity.y < 0.5 and abs(fmod(rotation_degrees, 360)) > 45:
		if !stuck: emit_signal("stuck", true)
		stuck = true
	else: 
		if stuck: emit_signal("stuck", false)
		stuck = false
#	print(linear_velocity.length())

func pollInput() -> void:
	inputR = Input.get_action_strength("right")
	inputL = Input.get_action_strength("left")
	if invertDirections:
		var a := inputR
		inputR = inputL; inputL = a

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
#		var size := get_viewport().size.x
#		get_viewport_transform()
#		if event.position.x < size: inputL = float(event.is_pressed())
#		else: inputR = float(event.is_pressed())
		var size := get_viewport().size.x * 0.5
		if event.position.x < size: action("left", event.is_pressed())
		else: action("right", event.is_pressed())
	else:
		if event.is_action_pressed("restart"):
			get_tree().reload_current_scene()

func action(name: String, trigger: bool) -> void:
	if trigger: Input.action_press(name); else: Input.action_release(name)

func getScreenPos() -> Vector2:
	return get_viewport_transform() * (get_global_transform() * position)