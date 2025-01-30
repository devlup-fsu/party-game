extends StaticBody3D

var time_passed: float = 0.0
var original_position: Vector3

var oscillate_vector: Vector3
var oscillate_speed: float
var oscillate_amplitude: float


func _ready() -> void:
	original_position = global_transform.origin


func move_oscillate(delta: float):
	time_passed += delta * oscillate_speed
	var displacement = sin(time_passed) * oscillate_amplitude
	var new_position = original_position + oscillate_vector.normalized() * displacement
	global_transform.origin = new_position


func _process(delta: float) -> void:
	move_oscillate(delta)
