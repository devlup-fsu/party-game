extends Area3D
class_name DragonGameFireball

const DESTROY_POSITION_Z = 7.5

const TRAVEL_TIME = 1.25

var speed = 0.0

func _physics_process(delta: float) -> void:
	global_position += Vector3.BACK * speed * delta
	if global_position.z > DESTROY_POSITION_Z:
		queue_free()
