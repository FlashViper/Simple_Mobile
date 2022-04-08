extends RigidBody2D

signal stuck(isStuck)

export var thrusterForce := 10
export var thrusterOffsetX := 13
export var maxSpeedY := 50
export var torqueCorrection := 1200.0
export (float, 0, 90) var torqueCorrectionThreshold := 5
export var fallingGramvity := 0.8

onready var rDir := Vector2(-thrusterOffsetX , 0)#20)
onready var lDir := Vector2(thrusterOffsetX, 0)#20)
onready var originalGravity := gravity_scale

var inputR : float
var inputL : float
var invertDirections := false

var onGround : bool
var stuck : bool

func _enter_tree() -> void:
	Globals.player = self

func _ready() -> void:
	var test := Physics2DTestMotionResult.new()
	if test_motion(Vector2.DOWN * 35, true, 0.08, test):
		position += test.motion
	invertDirections = SettingsManager.settings.get("invert-controls", false)

func _process(delta: float) -> void:
	$Visual.animate(self)

#todo: analize for frame-dependance
func _physics_process(delta: float) -> void:
#	if Globals.state == Globals.STATE_TRANSITION:
#		mode = MODE_STATIC
#		return
#	else:
#		mode = MODE_RIGID
	
	pollInput()
	onGround = get_colliding_bodies().size() > 0
#	applied_force = Vector2.ZERO
	apply_impulse((rDir).rotated(rotation)* inputL, -transform.y * thrusterForce * inputL * delta)
	apply_impulse((lDir).rotated(rotation)* inputR, -transform.y * thrusterForce * inputR * delta)
	
	if SettingsManager.settings["torque-correction"]:
		if inputL + inputR < 0.1:
			if abs((transform.x).angle()) > deg2rad(torqueCorrectionThreshold):
				apply_torque_impulse(torqueCorrection * delta * -sign(transform.x.angle()))
	
	if SettingsManager.settings["lower-falling-gravity"]:
		gravity_scale = originalGravity if linear_velocity.y < 0 else fallingGramvity
	
	if (
		linear_velocity.y > -8 
		and linear_velocity.y < 0.5 
		and abs(fmod(rotation_degrees, 360)) > 45
		and onGround
	):
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
			TransitionManager.reloadScene()

func action(name: String, trigger: bool) -> void:
	if trigger: Input.action_press(name); else: Input.action_release(name)

func getScreenPos() -> Vector2:
	return get_viewport_transform() * (get_global_transform() * position)
