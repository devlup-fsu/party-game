extends StaticBody3D

var moving_wall_vector: Vector3 = Vector3(1, 0, 0)
var speed: float = 1.0
var amplitude: float = 5.0
var time_passed: float = 0.0
var original_position: Vector3

func _ready() -> void:
	original_position = global_transform.origin

func _process(delta: float) -> void:
	time_passed += delta * speed
	var displacement = sin(time_passed) * amplitude
	var new_position = original_position + moving_wall_vector.normalized() * displacement
	global_transform.origin = new_position
