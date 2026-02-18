class_name Player
extends CharacterBody3D

@export var speed := 6.0
@export var sprint_speed := 10.0
@export var jump_velocity := 4.5

@export var mouse_sensitivity := 0.002

# controller look tuning (separate from mouse)
@export var stick_look_sensitivity := 2.5  # radians per second-ish (scaled by delta)
@export var stick_deadzone := 0.15
@export var invert_y := false

@export var gravity := 9.8

@onready var camera: Camera3D = $Camera3D
@onready var arms: Arms = $Arms

var y_rotation := 0.0
var x_rotation := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	# Mouse look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		y_rotation -= event.relative.x * mouse_sensitivity
		x_rotation -= event.relative.y * mouse_sensitivity
		x_rotation = clamp(x_rotation, deg_to_rad(-90), deg_to_rad(90))

		rotation.y = y_rotation
		camera.rotation.x = x_rotation

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	_apply_controller_look(delta)

	# gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var sprinting = Input.is_action_pressed("sprint")
	var active_speed = sprint_speed if sprinting else speed

	if sprinting:
		arms.disable()
	else:
		arms.enable()

	if direction:
		velocity.x = direction.x * active_speed
		velocity.z = direction.z * active_speed
	else:
		velocity.x = move_toward(velocity.x, 0, active_speed)
		velocity.z = move_toward(velocity.z, 0, active_speed)

	move_and_slide()

func _apply_controller_look(delta: float) -> void:
	# Build a look vector from your 4 look actions
	# x: right-left, y: down-up (we'll flip as needed)
	var look = Input.get_vector("look_left", "look_right", "look_up", "look_down")

	# Deadzone (prevents drift)
	if look.length() < stick_deadzone:
		return

	# Optional: re-normalize so deadzone doesn't slow the start too much
	look = look.normalized()

	# Apply rotations (stick sensitivity scaled by delta)
	y_rotation -= look.x * stick_look_sensitivity * delta

	var y_sign := 1.0 if invert_y else -1.0
	x_rotation += look.y * stick_look_sensitivity * delta * y_sign

	x_rotation = clamp(x_rotation, deg_to_rad(-90), deg_to_rad(90))

	rotation.y = y_rotation
	camera.rotation.x = x_rotation
