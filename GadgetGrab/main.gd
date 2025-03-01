extends Node3D
@export var falling_orb_scene = preload("res://GadgetGrab/falling_objs/falling_orb.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func spawn_random_object(position: Vector3):
	var instance = falling_orb_scene.instantiate()
	add_child(instance)
	instance.position = position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var pos : Vector3
	pos.x = randf_range(-30,30)
	pos.y = 10
	pos.z = randf_range(-30,30)
	var random = randf_range(0,1000)
	if random < 9:
		if (((pos.x*pos.x) +(pos.z*pos.z)) <= 225):
			spawn_random_object(pos)
	
