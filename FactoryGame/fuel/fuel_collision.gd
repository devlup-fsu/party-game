extends Area3D

@onready var parent: Fuel = get_parent()

func _on_body_entered(body: Node3D) -> void:
	if body is FactoryPlayer and body.carried_fuel_node == null and body.current_pickup_cooldown == 0:
		body.carried_fuel_node = parent
		parent.carrier = body
		parent.set_collision_mask_value(4, false)
		parent.rotation = Vector3(0, 0, 0)
		if parent.near_generator:
			parent.parent_generator.surrounding_fuel_count -= 1
			parent.near_generator = false
