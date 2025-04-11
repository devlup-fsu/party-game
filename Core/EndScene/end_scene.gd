extends Node3D
class_name EndScene


const self_scene: PackedScene = preload("res://Core/EndScene/end_scene.tscn")


enum EndSceneState {
	WAIT,
	BLAST_OFF,
	FLY,
	IDLE
}

const TIMINGS = [
	1.0,
	3.0,
	7.5,
	-1.0
]


const SHIP_HEIGHTS = [
	60.0,
	45.0,
	30.0,
	15.0
]


var placements: Array[Scores.Place] = [Scores.Place.FIRST, Scores.Place.SECOND, Scores.Place.THIRD, Scores.Place.FOURTH]

var cumulative_time = 0.0
var state = EndSceneState.WAIT
var current_time_bound = TIMINGS[state]


static func create(placements: Array[Scores.Place]) -> EndScene:
	var scene = self_scene.instantiate()
	scene.placements = placements
	return scene


func _physics_process(delta: float) -> void:
	if state == EndSceneState.IDLE:
		if Controls.is_action_just_pressed(Controls.Player.ONE, 'core_player_jump'):
			SceneManager._pop_scene()
	
	else:
		cumulative_time += delta
		if cumulative_time >= current_time_bound:
			state += 1
			current_time_bound = TIMINGS[state]
			if state == EndSceneState.BLAST_OFF:
				var i = 0
				for ship in $Ships.get_children():
					ship.get_child(0).visible = true
					ship.target_height = SHIP_HEIGHTS[placements[i]]
					i += 1
			
			elif state == EndSceneState.FLY:
				for ship in $Ships.get_children():
					ship.should_fly = true
			
			elif state == EndSceneState.IDLE:
				$ContinueLabel.visible = true
