class_name WipeoutSweeper
extends AnimatableBody3D

const ROT_DEG_VEL = 45


func _physics_process(delta: float) -> void:
	global_rotation_degrees.y += ROT_DEG_VEL * delta
