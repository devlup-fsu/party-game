extends Area3D

@onready var parent: Node3D = get_parent()


func _process(delta: float) -> void:
	var force_vector = Vector3(1, 0, 0)
	force_vector.y = 0
	for body in get_overlapping_bodies():
		if body is Fuel:
			body.apply_central_force(force_vector)
		
