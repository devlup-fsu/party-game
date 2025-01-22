extends Area3D

@onready var parent: Fuel = get_parent()


func _physics_process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is FactoryPlayer:
			# Pickup fuel check
			if body.carried_fuel_node == null \
			and body.current_pickup_cooldown == 0 \
			and not body.is_stunned \
			and not parent.being_carried \
			and (not parent.is_dangerous or parent.carrier == body):
				body.carried_fuel_node = parent
				parent.carrier = body
				parent.being_carried = true
				parent.rotation = Vector3.ZERO
		
			# Stun check
			if parent.is_dangerous and parent.carrier != body:
				var drop_vector = body.position - parent.position
				drop_vector.y = randf_range(0.0, 1.0)
				body.stun(drop_vector)
				parent.is_dangerous = false
		
		elif body is CSGBox3D:  # Floor and walls. Would like for a better check here as later this may be an issue
			parent.is_dangerous = false


func _on_area_entered(area: Area3D) -> void:
	if area.get_collision_layer_value(5):  # Hit fall boundary
		parent.parent_generator.parent.amount_fuel_objects -= 1
		queue_free()
