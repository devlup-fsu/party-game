extends StaticBody3D

var type: FactoryMazeGen.DynamicWallType
var time_passed: float = 0.0
var original_position: Vector3

var oscillate_vector: Vector3
var oscillate_speed: float
var oscillate_amplitude: float

var rotate_center: Vector2
var rotate_speed: float


func _ready() -> void:
	original_position = global_transform.origin


func move_oscillate(delta: float):
	time_passed += delta * oscillate_speed
	var displacement = sin(time_passed) * oscillate_amplitude
	var new_position = original_position + oscillate_vector.normalized() * displacement
	global_transform.origin = new_position


func move_rotate(delta: float):
	var current_pos_2d = Vector2(global_transform.origin.x, global_transform.origin.z)
	var radius = current_pos_2d.distance_to(rotate_center)
	
	if radius < 0.01:
		rotate_y(rotate_speed * delta)
	else:
		var current_angle = (current_pos_2d - rotate_center).angle()
		var new_angle = current_angle + rotate_speed * delta
		var new_pos_2d = rotate_center + Vector2(cos(new_angle), sin(new_angle)) * radius
		global_transform.origin = Vector3(new_pos_2d.x, global_transform.origin.y, new_pos_2d.y)
		rotate_y(-rotate_speed * delta)


func _process(delta: float) -> void:
	if type == FactoryMazeGen.DynamicWallType.OSCILLATE:
		move_oscillate(delta)
	elif type == FactoryMazeGen.DynamicWallType.ROTATE:
		move_rotate(delta)
