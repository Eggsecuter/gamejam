class_name Arm
extends Node3D

@export var inactive_arm_rotation := -40.0
@export var active_arm_rotation := 10.0
@export var rotation_speed := 120.0

var target_rotation_x : float

func _ready() -> void:
	# internally rotation is handled in degrees
	inactive_arm_rotation = deg_to_rad(inactive_arm_rotation)
	active_arm_rotation = deg_to_rad(active_arm_rotation)
	rotation_speed = deg_to_rad(rotation_speed)

	target_rotation_x = inactive_arm_rotation
	rotation.x = target_rotation_x

func _process(delta: float) -> void:
	rotation.x = move_toward(rotation.x, target_rotation_x, rotation_speed * delta)

func activate():
	target_rotation_x = active_arm_rotation

func deactivate():
	target_rotation_x = inactive_arm_rotation
