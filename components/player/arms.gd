class_name Arms
extends Node3D

@onready var left_arm: Arm = $LeftArm
@onready var right_arm: Arm = $RightArm

var enabled = true
var active_arm: Arm

func enable():
	enabled = true

func disable():
	enabled = false

	_reset()
	active_arm = null

func _unhandled_input(event: InputEvent) -> void:
	if not enabled:
		return

	_reset()

	if event.is_action_pressed("right_arm"):
		active_arm = right_arm
	elif event.is_action_pressed("left_arm"):
		active_arm = left_arm
	# handle track pad
	elif event is InputEventPanGesture:
		if abs(event.delta.y) > abs(event.delta.x):
			if event.delta.y > 0:
				active_arm = right_arm
			else:
				active_arm = left_arm

	if active_arm != null:
		active_arm.activate()

func _reset():
	if active_arm != null:
		active_arm.deactivate()
