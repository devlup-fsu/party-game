extends Area3D

const LASER_SPEED = 50.0 # Speed of the laser

var direction : Vector3 = Vector3()
var shooter : BSMPlayer

func _ready() -> void:
	$MeshInstance3D.get_surface_override_material(0).albedo_color = shooter.color


func _physics_process(delta: float) -> void:
	# Move the laser forward
	global_transform.origin += direction * LASER_SPEED * delta
	
	# Optional: Remove the laser after it travels far enough or collides
	if global_transform.origin.length() > 1000: # or some distance threshold
		queue_free()
	

# Set the laser's direction
func set_direction(dir: Vector3) -> void:
	direction = dir.normalized()
	


func _on_body_entered(body: Node3D) -> void:
	if body is StaticBody3D:
		queue_free()
	
	if body == shooter:
		return
	
	if body is BSMPlayer:
		body.lives_remaining -= 1
		print(body.name + " was shot by " + shooter.name)
		print(body.name + " has " + str(body.lives_remaining) + " lives remaining")
		print()
