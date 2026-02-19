class_name Player
extends CharacterBody3D

@export var speed := 6.0
@export var sprint_speed := 10.0
@export var jump_velocity := 4.5

@export var gravity := 9.8

@onready var arms: Arms = $Arms

func _physics_process(delta):
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

func _on_camera_3d_on_turn(y_delta: float) -> void:
	rotation.y += y_delta
