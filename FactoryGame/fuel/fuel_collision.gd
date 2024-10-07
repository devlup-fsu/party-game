extends Area3D

@onready var parent: Fuel = get_parent()

# NOTE: `being_carried` may enable port priority on same frame pickups
func _on_body_entered(body: Node3D) -> void:
	if body is FactoryPlayer \
	and body.carried_fuel_node == null \
	and body.current_pickup_cooldown == 0 \
	and not parent.being_carried:
		body.carried_fuel_node = parent
		parent.carrier = body
		parent.being_carried = true
		parent.rotation = Vector3(0, 0, 0)
