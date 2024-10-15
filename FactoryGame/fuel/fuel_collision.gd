extends Area3D

@onready var parent: Fuel = get_parent()

# NOTE: `being_carried` may enable port priority on same frame pickups
func _on_body_entered(body: Node3D) -> void:
	if body is FactoryPlayer:
		if body.carried_fuel_node == null \
		and body.current_pickup_cooldown == 0 \
		and not body.isStunned \
		and not parent.being_carried \
		and (not parent.ifDangerous or parent.carrier == body):
			body.carried_fuel_node = parent
			parent.carrier = body
			parent.being_carried = true
			parent.rotation = Vector3.ZERO
		
		if parent.ifDangerous == true and parent.carrier != body:
			body.set_stunned_material()
			body.isStunned = true
			if body.carried_fuel_node != null:
				body.carried_fuel_node.being_carried = false
				body.carried_fuel_node = null
			parent.ifDangerous = false
	if body is CSGBox3D: # Floor and walls. Would like for a better check here as later this may be an issue
		parent.ifDangerous = false
