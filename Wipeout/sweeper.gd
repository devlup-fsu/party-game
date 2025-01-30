class_name WipeoutSweeper
extends AnimatableBody3D

var rotational_vel_deg = 45


func _physics_process(delta: float) -> void:
	global_rotation_degrees.y += rotational_vel_deg * delta


func _on_timer_timeout() -> void:
	rotational_vel_deg += 22.5
