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
	# Convert current position to 2D for rotation calculation
	var current_pos_2d = Vector2(global_transform.origin.x, global_transform.origin.z)
	
	# Calculate the radius (distance from center)
	var radius = current_pos_2d.distance_to(rotate_center)
	
	# Check if center is (approximately) on the wall's axis
	var forward = -global_transform.basis.z # Wall's forward direction
	var to_center = Vector3(rotate_center.x - current_pos_2d.x, 0, rotate_center.y - current_pos_2d.y)
	var center_distance_from_axis = to_center.cross(forward).length()
	
	if center_distance_from_axis < 0.01:
		rotate_y(rotate_speed * delta)
	else:
		# Calculate current angle and new angle for orbital rotation
		var current_angle = (current_pos_2d - rotate_center).angle()
		var new_angle = current_angle + rotate_speed * delta
		
		# Calculate new position in 2D
		var new_pos_2d = rotate_center + Vector2(cos(new_angle), sin(new_angle)) * radius
		
		# Convert back to 3D position, maintaining Y coordinate
		var new_position = Vector3(new_pos_2d.x, global_transform.origin.y, new_pos_2d.y)
		global_transform.origin = new_position
		
		# Make the wall face the center point
		look_at(Vector3(rotate_center.x, global_transform.origin.y, rotate_center.y), Vector3.UP)


func _process(delta: float) -> void:
	if type == FactoryMazeGen.DynamicWallType.OSCILLATE:
		move_oscillate(delta)
	elif type == FactoryMazeGen.DynamicWallType.ROTATE:
		move_rotate(delta)
