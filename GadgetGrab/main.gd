extends Node3D

@export var falling_orb_scene = preload("res://GadgetGrab/falling_objs/falling_orb.tscn")
@export var a_falling_obj = preload("res://GadgetGrab/falling_objs_scenes/a_falling_obj.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func spawn_random_object(position: Vector3):
	var falling_obj_instance = a_falling_obj.instantiate()
	add_child(falling_obj_instance)
	falling_obj_instance.position = position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var pos : Vector3
	pos.x = randf_range(-230,230)
	pos.y = 10
	pos.z = randf_range(-230,230)
	#var random = randf_range(0,800)
	if (((pos.x*pos.x) +(pos.z*pos.z)) <= 225):
		spawn_random_object(pos)
	
