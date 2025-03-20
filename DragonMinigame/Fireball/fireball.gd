extends Area3D


const DESTROY_POSITION_Z = 7.5

var speed = 1.0;


func _physics_process(delta: float) -> void:
	global_position += Vector3.BACK * speed * delta
	if global_position.z > DESTROY_POSITION_Z:
		queue_free()
