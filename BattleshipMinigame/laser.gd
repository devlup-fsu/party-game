extends Area3D

const LASER_SPEED = 50.0 # Speed of the laser

var direction : Vector3 = Vector3()

func _physics_process(delta: float) -> void:
	# Move the laser forward
	global_transform.origin += direction * LASER_SPEED * delta
	
	# Optional: Remove the laser after it travels far enough or collides
	if global_transform.origin.length() > 1000: # or some distance threshold
		queue_free()

# Set the laser's direction
func set_direction(dir: Vector3) -> void:
	direction = dir.normalized()
