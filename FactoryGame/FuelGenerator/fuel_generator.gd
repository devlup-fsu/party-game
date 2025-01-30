extends Node3D
class_name FuelGenerator

var fuel = preload("res://FactoryGame/Fuel/fuel.tscn")

@onready var parent: Node3D = get_parent()

@export var generate_interval := 10.0  # seconds
@export var generate_interval_variance := 0.25
@export var generate_interval_offset := 0.0

const GENERATE_DISTANCE_VARIANCE := 0.5

var generate_timer := 0.0

# Stores fuel types in random order that get "pulled" out of the bucket.
# This ensures that each fuel type will be generated once before restarting.
var fuel_type_bucket: Array = []


func _ready():
	if not Engine.is_editor_hint():
		$Sprite.visible = false;
	generate_timer = generate_interval_offset


func get_bucket_value(bucket: Array, bucket_size: int) -> int:
	if len(bucket) == 0:
		bucket.append_array(range(bucket_size))
		bucket.shuffle()
	return bucket.pop_front()


func rand_angle() -> float:
	return deg_to_rad(randi_range(0, 360))


func generate_fuel():
	var distance = randf_range(-GENERATE_DISTANCE_VARIANCE, GENERATE_DISTANCE_VARIANCE)
	var facing_vector = Vector2.from_angle(rand_angle()) * distance
	var shift_vector = Vector3(facing_vector.x, 0, facing_vector.y)
	var angular_velocity = Vector3(randf_range(-2, 2), randf_range(-2, 2), randf_range(-2, 2)) 
	
	var fuel_node: Fuel = fuel.instantiate()
	fuel_node.position = $GenerateLocation.position
	fuel_node.translate_object_local(shift_vector)
	fuel_node.angular_velocity = angular_velocity
	fuel_node.parent_generator = self
	
	add_child(fuel_node)
	parent.amount_fuel_objects += 1


func _process(delta: float) -> void:
	generate_timer -= delta
	if generate_timer <= 0:
		generate_timer = generate_interval + randf_range(0, generate_interval_variance)
		if parent.amount_fuel_objects < parent.fuel_object_limit:
			generate_fuel()
