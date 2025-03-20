extends Node3D


@onready var FIREBALL_MATERIALS = [
	preload("res://DragonMinigame/Fireball/Materials/up_material.tres"),
	preload("res://DragonMinigame/Fireball/Materials/down_material.tres")
]

@onready var fireball = preload("res://DragonMinigame/Fireball/fireball.tscn")


enum WaveObject {
	FIREBALL,
	TENTACLE
}


const FIREBALL_OFFSETS = [
	Vector3(0, 1, 0),
	Vector3(0, -0.5, 0)
]

var wave_number = 0
var wave_obstacle_timer = 0.0
var wave_obstacle_interval = 1.0
var wave_cooldown_timer = 0.0
var wave_cooldown_interval = 3.0
var wave_objects = []


func get_amount_wave_objects(wave_number: int) -> int:
	return min(floor(0.5 * wave_number + 2), 10)


func new_wave():
	wave_number += 1
	var amount_objects = get_amount_wave_objects(wave_number)
	for i in range(amount_objects):
		var obj = WaveObject.FIREBALL  # TODO: replace this with a randomly generated object
		wave_objects.append(obj)


func spawn_fireballs():
	var direction_int = randi_range(0, 1)
	var offset: Vector3 = FIREBALL_OFFSETS[direction_int]
	var material = FIREBALL_MATERIALS[direction_int]
	for spawn_location in %FireballSpawners.get_children():
		var new_fireball = fireball.instantiate()
		new_fireball.position = spawn_location.global_position + offset
		new_fireball.speed = 15.0
		var fireball_mesh: MeshInstance3D = new_fireball.get_child(1)
		fireball_mesh.set_surface_override_material(0, material)
		%Fireballs.add_child(new_fireball)


func _ready() -> void:
	new_wave()


func _process(delta: float) -> void:
	if wave_cooldown_timer != 0.0:
		wave_cooldown_timer = move_toward(wave_cooldown_timer, 0.0, delta)
	else:
		wave_obstacle_timer = move_toward(wave_obstacle_timer, wave_obstacle_interval, delta)
		if wave_obstacle_timer == wave_obstacle_interval:
			wave_obstacle_timer = 0
			match wave_objects.pop_back():
				WaveObject.FIREBALL:
					spawn_fireballs()
				WaveObject.TENTACLE:
					pass
			if len(wave_objects) == 0:
				wave_cooldown_timer = wave_cooldown_interval
				new_wave()
