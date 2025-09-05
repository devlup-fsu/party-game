extends Node3D

@export var a_falling_obj = preload("res://GadgetGrab/falling_objs_scenes/a_falling_obj.tscn")
@export var players: Array[GrabPlayer]
@export var scores: Array[Label]


var total_time_elapsed : float = 0
var spawn_timer : float = 0


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


func _spawn_random_object(position: Vector3):
	var falling_obj_instance = a_falling_obj.instantiate()
	falling_obj_instance.falling_obj_res = resources.pick_random()
	add_child(falling_obj_instance)
	falling_obj_instance.position = position

func _get_spawn_time(time_elapsed: float):
	return (-1 * time_elapsed / 22) + 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for i in range(0, 4, 1):
		scores[i].text = str(players[i].objs_collected)

	total_time_elapsed += _delta
	spawn_timer += _delta
	
	if total_time_elapsed >= 60.0:
		var unique_scores: Array[int] = []
		for player in players:
			if player.objs_collected not in unique_scores:
				unique_scores.append(player.objs_collected)
		unique_scores.sort()
		unique_scores.reverse()
		
		var placements: Array[Scores.Place] = [0, 0, 0, 0]
		for player in players:
			placements[player.player] = unique_scores.find(player.objs_collected)
		
		SceneManager.exit_minigame(placements[0], placements[1], placements[2], placements[3])
	
	#print(spawn_timer)
	
	if (spawn_timer > _get_spawn_time(total_time_elapsed)):
		var pos : Vector3
		pos.x = randf_range(-12.5,12.5)
		pos.y = 10
		pos.z = randf_range(-10,10)
		_spawn_random_object(pos)
		spawn_timer = 0
