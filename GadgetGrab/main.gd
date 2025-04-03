extends Node3D

@export var a_falling_obj = preload("res://GadgetGrab/falling_objs_scenes/a_falling_obj.tscn")

func get_all_resources() -> Array[FallingObjRes]:

	
	var dir = DirAccess.open("res://GadgetGrab/GradgetGrabResources")
	
	if not dir:
		return []
	
	var resources : Array[FallingObjRes] = []
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.get_extension() == "tres":
			var resource = ResourceLoader.load("res://GadgetGrab/GradgetGrabResources/" + file_name)
			if resource is FallingObjRes:
				resources.append(resource)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	return resources

var rng = RandomNumberGenerator.new()
var resources : Array[FallingObjRes] = get_all_resources()

func _ready():
	rng.randomize()


func spawn_random_object(position: Vector3):
	var falling_obj_instance = a_falling_obj.instantiate()
	falling_obj_instance.falling_obj_res = resources.pick_random()
	add_child(falling_obj_instance)
	falling_obj_instance.position = position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var pos : Vector3
	pos.x = randf_range(-100,100)
	pos.y = 10
	pos.z = randf_range(-100,100)
	#var random = randf_range(0,800)
	if (((pos.x*pos.x) +(pos.z*pos.z)) <= 225):
		spawn_random_object(pos)
	
