extends Node3D
class_name FuelGenerator

var fuel = preload("res://FactoryGame/fuel/fuel.tscn")

@onready var parent: Node3D = get_parent()

const GENERATE_INTERVAL := 5.0  # seconds
const GENERATE_INTERVAL_VARIANCE := 0.25
const GENERATE_DISTANCE := 0.0
const GENERATE_DISTANCE_VARIANCE := 1.25
const MAX_SURROUNDING_FUEL := 3

var generate_timer := 0.0
var surrounding_fuel_count := 0

# Stores fuel types in random order that get "pulled" out of the bucket.
# This ensures that each fuel type will be generated once before restarting.
var fuel_type_bucket: Array = []


func get_bucket_value(bucket: Array, bucket_size: int) -> int:
	if len(bucket) == 0:
		bucket.append_array(range(bucket_size))
		bucket.shuffle()
	return bucket.pop_front()

func rand_angle() -> float:
	return deg_to_rad(randi_range(0, 360))


func generate_fuel():
	var distance := GENERATE_DISTANCE + randf_range(-GENERATE_DISTANCE_VARIANCE, GENERATE_DISTANCE_VARIANCE)
	var facing_vector := Vector2.from_angle(rand_angle()) * distance
	var shift_vector := Vector3(facing_vector.x, 2, facing_vector.y)
	var fuel_node: Fuel = fuel.instantiate()
	
	fuel_node.set_type(get_bucket_value(fuel_type_bucket, 4))
	fuel_node.translate_object_local(shift_vector)
	fuel_node.rotate_x(rand_angle())
	fuel_node.rotate_y(rand_angle())
	fuel_node.rotate_z(rand_angle())
	fuel_node.parent_generator = self
	
	add_child(fuel_node)
	surrounding_fuel_count += 1
	parent.amount_fuel_objects += 1

func _process(delta: float) -> void:
	generate_timer -= delta
	if generate_timer <= 0:
		generate_timer = GENERATE_INTERVAL + randi_range(0, GENERATE_INTERVAL_VARIANCE)
		if surrounding_fuel_count < MAX_SURROUNDING_FUEL and parent.amount_fuel_objects < parent.fuel_object_limit:
			generate_fuel()
