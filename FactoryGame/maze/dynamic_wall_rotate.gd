extends StaticBody3D

var rotate_center: Vector2
var rotate_speed: float


func move_rotate(delta: float):
	var current_pos_2d = Vector2(global_transform.origin.x, global_transform.origin.z)
	var radius = current_pos_2d.distance_to(rotate_center)
	
	if radius < 0.01:  # Rotate on axis
		rotate_y(rotate_speed * delta)
	else:
		var current_angle = (current_pos_2d - rotate_center).angle()
		var new_angle = current_angle + rotate_speed * delta
		var new_pos_2d = rotate_center + Vector2(cos(new_angle), sin(new_angle)) * radius
		global_transform.origin = Vector3(new_pos_2d.x, global_transform.origin.y, new_pos_2d.y)
		rotate_y(-rotate_speed * delta)


func _process(delta: float) -> void:
	move_rotate(delta)
