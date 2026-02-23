class_name VendingMachine
extends Node

@export var items: Array[PackedScene] = []

@onready var item_spawn: Node3D = $ItemSpawn

func _on_interact() -> void:
	if items.is_empty():
		return

	var scene = items.pick_random()
	var instance = scene.instantiate()
	add_child(instance)

	if instance is RigidBody3D:
		instance.position = item_spawn.position

		var direction = Vector3(
			randf_range(-1.0, 1.0),
			randf_range(0.5, 1.5),
			randf_range(0.5, 1.0)
		).normalized()

		var speed = randf_range(1.0, 3.0)
		instance.linear_velocity = direction * speed
