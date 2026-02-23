class_name InteractRay
extends RayCast3D

@export var inactive_color: Color = Color.WHITE
@export var active_color: Color = Color.RED

@onready var mouse: ColorRect = $'../../HUD/Mouse'

func _process(_delta: float) -> void:
	var colliding = false

	if is_colliding():
		var collider = get_collider()

		if collider is Interactable:
			colliding = true

			if Input.is_action_just_pressed("interact"):
				collider.on_interact.emit()

	mouse.color = active_color if colliding else inactive_color
