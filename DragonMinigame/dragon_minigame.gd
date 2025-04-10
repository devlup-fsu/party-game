extends Node3D


@export var fireball_travel_time = 1.25

@onready var FIREBALL_MATERIALS = [
	preload("res://DragonMinigame/Fireball/Materials/up_material.tres"),
	preload("res://DragonMinigame/Fireball/Materials/down_material.tres")
]


enum WaveAction {
	FIREBALL_UP,
	FIREBALL_DOWN,
	TENTACLE_LEFT,
	TENTACLE_RIGHT,
	TENTACLE_INDICATE_LEFT,
	TENTACLE_INDICATE_RIGHT
}


const FIREBALL_OFFSETS = [
	Vector3(0, 1, 0),	 # Up
	Vector3(0, -0.5, 0)  # Down
]

var wave_number = 0
var wave_obstacle_timer = 0.0
var wave_obstacle_interval = 1.0
var wave_cooldown_timer = 0.0
var wave_cooldown_interval = 3.0
var wave_objects = []

var cumulative_time = 0.0
var action_queue = []


func get_amount_wave_objects() -> int:
	return min(floor(0.5 * wave_number + 2), 10)


func get_obstacle_interval() -> float:
	return max(-0.1*wave_number + 1.5, 0.7)

## Fills the action queue with pairs of times and actions, indicating the time at which each action should be performed.
## base_time is the exact time at which the first obstacle will hit the players
func new_wave(base_time: float):
	wave_number += 1
	var amount_objects = get_amount_wave_objects()
	wave_obstacle_interval = get_obstacle_interval()
	for i in range(amount_objects):
		var hit_time = i * wave_obstacle_interval + base_time
		var obj = randi_range(0, 3)
		if obj < 2:  # fireball
			var activate_time = hit_time - DragonGameFireball.TRAVEL_TIME
			action_queue.append([activate_time, obj])
		else:  # tentacle
			var activate_time = hit_time - DragonGameTentacle.SLAM_DURATION
			var indicate_time = activate_time - DragonGameIndicator.INDICATOR_DELAY
			action_queue.append([indicate_time, obj+2])
			action_queue.append([activate_time, obj])
	action_queue.sort_custom(func(a, b): return a[0] < b[0])


# -- Action activation functions --

func spawn_fireballs(direction_int: int):
	var offset: Vector3 = FIREBALL_OFFSETS[direction_int]
	var material = FIREBALL_MATERIALS[direction_int]
	var spawner_position = %FireballSpawners.position.z
	for spawn_location in %FireballSpawners.get_children():
		var new_fireball = DragonGameFireball.create()
		new_fireball.position = spawn_location.global_position + offset
		new_fireball.speed = -spawner_position / DragonGameFireball.TRAVEL_TIME
		var fireball_mesh: MeshInstance3D = new_fireball.get_child(1)
		fireball_mesh.set_surface_override_material(0, material)
		%Fireballs.add_child(new_fireball)


func slam_tentacles(direction_int: int):
	var tentacles_to_slam = %Tentacles.get_child(direction_int)
	for tentacle in tentacles_to_slam.get_children():
		tentacle.slam()
	
	fade_tentacle_indicators(direction_int, false)  # fade out indicators


func fade_tentacle_indicators(direction_int: int, fade_in: bool):
	print('fading ', direction_int, ' ', fade_in)
	if direction_int == 0:  # left
		%TentacleIndicator1.fade(fade_in)
	else:
		%TentacleIndicator5.fade(fade_in)


func _ready() -> void:
	new_wave(wave_cooldown_interval)


func _physics_process(delta: float) -> void:
	cumulative_time += delta
	
	# Perform actions
	if len(action_queue) > 0:
		while action_queue and cumulative_time >= action_queue[0][0]:
			var action_time_and_obj = action_queue.pop_front()
			var action_obj = action_time_and_obj[1]
			if action_obj < 2:  # fireball
				spawn_fireballs(action_obj)
			elif action_obj < 4:  # tentacle
				slam_tentacles(action_obj-2)
			else:  # tentacle indicator
				fade_tentacle_indicators(action_obj-4, true)
	else:
		new_wave(cumulative_time + wave_cooldown_interval)
	
