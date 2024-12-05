extends Area3D


@onready var parent: Node3D = get_parent()


const MOVE_SPEED = 2


func _process(_delta: float) -> void:
	var velocity_vector := Vector3.RIGHT.rotated(Vector3(0, 1, 0), parent.rotation.y) * MOVE_SPEED
	for body in get_overlapping_bodies():
		if body is Fuel:
			body.linear_velocity.x = velocity_vector.x
			body.linear_velocity.z = velocity_vector.z
		
